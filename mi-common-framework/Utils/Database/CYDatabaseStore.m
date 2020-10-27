//
//  CYDatabaseManager.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYDatabaseStore.h"
#import "CYLogger.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

NSString * const kCYDatabaseStoreTableName = @"name";
NSString * const kCYDatabaseStoreTableAllFields = @"allFields";

@interface CYDatabaseStore ()

@property (nonatomic, strong, readwrite) FMDatabase *database;
@property (nonatomic, strong, readwrite) FMDatabaseQueue *databaseQueue;

@property (nonatomic, strong) NSArray *setupSQLs;
@property (nonatomic, strong) NSDictionary *tableDictionary;

@end

@implementation CYDatabaseStore

+ (instancetype)defaultStore {
    static id store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[[self class] alloc] init];
    });
    
    return store;
}

+ (NSString *)storeFilePath {
    NSString *cachedDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *dbName = [NSString stringWithFormat:@"%@.db", bundleID];
    NSString *filePath = [cachedDir stringByAppendingPathComponent:dbName];
    return filePath;
}

+ (NSString *)tableNameForKey:(NSString *)key {
    return [[[[self class] defaultStore] tableDictionary] valueForKey:key];
}

+ (void)setupWithSQLs:(NSArray *)SQLs tables:(NSDictionary *)tables {
    CYDatabaseStore *store = [[self class] defaultStore];
    store.setupSQLs = SQLs;
    store.tableDictionary = tables;
    
    NSString *filePath = [[self class] storeFilePath];
    CYLogInfo(@"DB file path: %@", filePath);
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    store.database = db;
    store.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    if (![db open]) {
        CYLogSerious(@"Could not open db.");
        
        return;
    }
    
    for (NSString *sql in SQLs) {
        [db executeUpdate:sql];
        FMDBQuickCheck(![db hadError]);
    }
    
    [db close];
}

+ (void)reset {
    CYDatabaseStore *store = [[self class] defaultStore];
    [store.database close];
    [store.databaseQueue close];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self class] storeFilePath];
    NSError *error = nil;
    [fileManager removeItemAtPath:filePath error:&error];
    if (error != nil) {
        CYLogSerious(@"Fail to delete db file, error: %@", error);
    } else {
        [[self class] setupWithSQLs:store.setupSQLs tables:store.tableDictionary];
    }
}

+ (void)clearData {
    // Abstract method
}

- (NSUInteger)getSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self class] storeFilePath];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
    return (NSUInteger)[attrs fileSize];
}

@end
