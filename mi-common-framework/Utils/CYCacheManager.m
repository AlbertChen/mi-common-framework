//
//  CYCacheManager.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 7/22/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYCacheManager.h"
#import "CYFilePathHelper.h"
#import "CYDatabaseStore.h"
#import "SDWebImageManager.h"

NSString * const CYCacheManagerDidClearNotification = @"CYCacheManagerDidClearNotification";

@interface CYCacheManager ()

@property (nonatomic, strong) NSString *cachedFolderPath;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation CYCacheManager

+ (instancetype)defaultManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        _cachedFolderPath = [cachesDirectory stringByAppendingPathComponent:@"com.cyl.CacheManager"];
        _ioQueue = dispatch_queue_create("com.cyl.CacheManager", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    // Image
    size += [[SDWebImageManager sharedManager].imageCache getSize];
    
    // Files
    dispatch_sync(self.ioQueue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:self.cachedFolderPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.cachedFolderPath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    
    if (size > 0) {
        size += [[CYDatabaseStore defaultStore] getSize];
    }
    
    return size;
}

- (void)clear {
    // Image
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    // DB
    [CYDatabaseStore clearData];
    
    // Files
    dispatch_sync(self.ioQueue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:self.cachedFolderPath error:NULL];
    });
    
    // URL Response cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CYCacheManagerDidClearNotification object:nil userInfo:nil];
}

- (id)getJSONObjectWithFileName:(NSString *)fileName userID:(NSString *)userID {
    NSData *JSONData = [self getDataWithFileName:fileName userID:userID];
    if (JSONData == nil) return nil;
    
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    if (error != nil) {
        CYLogSerious(@"[Cache Manager] Failed to get cached data, fileName: %@, error:%@", fileName, error);
    }
    
    return JSON;
}

- (void)saveJSONObject:(id)JSON withFileName:(NSString *)fileName userID:(NSString *)userID {
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:&error];
    if (error != nil) {
        CYLogSerious(@"[Cache Manager] Failed to save data, fileName: %@, error:%@", fileName, error);
    } else {
        [self saveData:JSONData withFileName:fileName userID:userID];
    }
}

- (void)saveData:(NSData *)data withFileName:(NSString *)fileName userID:(NSString *)userID {
    NSAssert(data != nil, @"data can not be nil.");
    NSAssert(fileName != nil, @"fileName can not be nil.");
    
    NSString *dir = self.cachedFolderPath;
    if (userID != nil) {
        dir = [NSString stringWithFormat:@"%@/%@", self.cachedFolderPath, userID];
    }
    CYCheckPathExsit(dir, YES);
    
    NSString *path = [dir stringByAppendingPathComponent:fileName];
    dispatch_async(self.ioQueue, ^{
        [data writeToFile:path atomically:YES];
    });
}

- (NSData *)getDataWithFileName:(NSString *)fileName userID:(NSString *)userID {
    NSString *relativePath = nil;
    if (userID == nil) {
        relativePath = fileName;
    } else {
        relativePath = [NSString stringWithFormat:@"%@/%@", userID, fileName];
    }
    NSString *path = [self.cachedFolderPath stringByAppendingPathComponent:relativePath];
    __block NSData *data = nil;
    dispatch_sync(self.ioQueue, ^{
        data = [NSData dataWithContentsOfFile:path];
    });
    
    return data;
}

@end
