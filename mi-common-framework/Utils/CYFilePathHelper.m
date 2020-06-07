//
//  NSBundle+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYFilePathHelper.h"

@implementation CYFilePathHelper

BOOL CYCreatePath(NSString *path) {
    BOOL success = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"%s, Fail to create path: %@ message: %@", __FUNCTION__, path, error.localizedDescription);
            success = NO;
        }
    }
    
    return success;
}

BOOL CYCheckPathExsit(NSString *path, BOOL createIfNeeded) {
    BOOL exist = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        exist = NO;
        if (createIfNeeded) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if (error != nil) {
                NSLog(@"%s, Fail to create path: %@ message: %@", __FUNCTION__, path, error.localizedDescription);
            } else {
                exist = YES;
            }
        }
    }

    return exist;
}

NSString * CYDocumentPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

NSString * CYCachesPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

NSString * CYTempPath() {
    NSString *path = NSTemporaryDirectory();
    return path;
}

NSString * CYPathForDocumentsResource(NSString *relativePath, BOOL createIfNeeded) {
    if ([relativePath isKindOfClass:[NSNumber class]]) {
        relativePath = [NSString stringWithFormat:@"%@", relativePath];
    }
    
    NSString *path = CYDocumentPath();
    path = [path stringByAppendingPathExtension:relativePath];
    if (createIfNeeded) {
        CYCheckPathExsit(path, createIfNeeded);
    }
    
    return path;
}

NSString * CYPathForCachesResource(NSString *relativePath, BOOL createIfNeeded) {
    if ([relativePath isKindOfClass:[NSNumber class]]) {
        relativePath = [NSString stringWithFormat:@"%@", relativePath];
    }
    
    NSString *path = CYCachesPath();
    path = [path stringByAppendingPathComponent:relativePath];
    if (createIfNeeded) {
        CYCheckPathExsit(path, createIfNeeded);
    }
    
    return path;
}

NSString * CYPathForTempResource(NSString *relativePath, BOOL createIfNeeded) {
    if ([relativePath isKindOfClass:[NSNumber class]]) {
        relativePath = [NSString stringWithFormat:@"%@", relativePath];
    }
    
    NSString *path = CYTempPath();
    path = [path stringByAppendingPathComponent:relativePath];
    if (createIfNeeded) {
        CYCheckPathExsit(path, createIfNeeded);
    }
    
    return path;
}

@end
