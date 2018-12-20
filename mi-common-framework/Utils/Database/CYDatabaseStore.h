//
//  CYDatabaseManager.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import <sqlite3.h>
#import "NSString+FMDB.h"
#import "CYDataModel+FMDB.h"

extern NSString * const kCYDatabaseStoreTableName;
extern NSString * const kCYDatabaseStoreTableAllFields;

@interface CYDatabaseStore : NSObject

+ (instancetype)defaultStore;

@property (nonatomic, strong, readonly) FMDatabase *database;
@property (nonatomic, strong, readonly) FMDatabaseQueue *databaseQueue;

+ (NSString *)storeFilePath;
+ (NSString *)tableNameForKey:(NSString *)key;

+ (void)setupWithSQLs:(NSArray *)SQLs tables:(NSDictionary *)tables; // sql: create table
+ (void)reset;
+ (void)clearData;

- (NSUInteger)getSize;

@end
