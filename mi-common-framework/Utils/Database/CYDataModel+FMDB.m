//
//  CYDataModel+FMDB.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYDataModel+FMDB.h"
#import <objc/runtime.h>
#import "CYDatabaseStore.h"
#import "CYLogger.h"
#import "NSString+FMDB.h"
#import "NSDictionary+CYAdditions.h"

@implementation CYDataModel (FMDB)

+ (NSArray<NSString *> *)fm_writeableProperties {
    NSMutableArray *properties = [NSMutableArray new];
    for (CYDataModelClassProperty *property in [self writeableProperties]) {
        if (property.isDataModel ||
            property.type == [NSArray class] ||
            property.type == [NSDictionary class] ||
            property.type == [NSMutableArray class] ||
            property.type == [NSMutableDictionary class]) {
            continue;
        }
        
        [properties addObject:property.name];
    }
    
    return properties;
}

- (void)fm_updateObjectWithKey:(NSString *)key {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [self fm_updateObjectWithKey:key databaseQueue:queue];
}

- (void)fm_updateObjectWithKey:(NSString *)key databaseQueue:(FMDatabaseQueue *)databaseQueue {
    NSAssert(key != nil && key.length > 0, @"Error: key cannot be nil.");
    if ([self valueForKey:key] == nil) return;
    
    NSDictionary *conditions = @{ key: [self valueForKey:key] };
    [self fm_updateObjectWithConditions:conditions databaseQueue:databaseQueue];
}

- (void)fm_updateObjectWithConditions:(NSDictionary *)conditions {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [self fm_updateObjectWithConditions:conditions databaseQueue:queue];
}

- (void)fm_updateObjectWithConditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue {
    NSDictionary *attributes = [NSDictionary dictionaryWithDataModel:self];
    [[self class] fm_updateObjectsWithAttributes:attributes conditions:conditions databaseQueue:databaseQueue];
}

+ (void)fm_insertObjectWithAttributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [[self class] fm_insertObjectWithAttributes:attributes userInfo:userInfo databaseQueue:queue];
}

+ (void)fm_insertObjectWithAttributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo databaseQueue:(FMDatabaseQueue *)databaseQueue {
    [databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSArray *values = nil;
        NSString *sql = [NSString insertSQLWithTableName:tableName attributes:attributes userInfo:userInfo values:&values allFields:[self fm_writeableProperties]];
        NSError *error = nil;
        [db executeUpdate:sql values:values error:&error];
        if (error != nil) {
            CYLogSerious(@"DB: Failed to insert data, error: %@", error);
        }
    }];
}

+ (void)fm_insertObjectsWithAttributesArray:(NSArray *)attributesArray userInfo:(NSDictionary *)userInfo {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [[self class] fm_insertObjectsWithAttributesArray:attributesArray userInfo:userInfo databaseQueue:queue];
}

+ (void)fm_insertObjectsWithAttributesArray:(NSArray *)attributesArray userInfo:(NSDictionary *)userInfo databaseQueue:(FMDatabaseQueue *)databaseQueue {
    [databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        for (NSDictionary *attributes in attributesArray) {
            NSArray *values = nil;
            NSString *sql = [NSString insertSQLWithTableName:tableName attributes:attributes userInfo:userInfo values:&values allFields:[self fm_writeableProperties]];
            NSError *error = nil;
            [db executeUpdate:sql values:values error:&error];
            if (error != nil) {
                CYLogSerious(@"DB: Failed to insert data, error: %@", error);
            }
        }
    }];
}

+ (void)fm_updateObjectsWithAttributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [[self class] fm_updateObjectsWithAttributes:attributes conditions:conditions databaseQueue:queue];
}

+ (void)fm_updateObjectsWithAttributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue {
    [databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSArray *values = nil;
        NSString *sql = [NSString updateSQLWithTableName:tableName attributes:attributes conditions:conditions values:&values allFields:[self fm_writeableProperties]];
        NSError *error = nil;
        [db executeUpdate:sql values:values error:&error];
        if (error != nil) {
            CYLogSerious(@"DB: Failed to update data, error: %@", error);
        }
    }];
}

+ (void)fm_deleteObjectsWithCondition:(NSString *)condition {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [[self class] fm_deleteObjectsWithCondition:condition databaseQueue:queue];
}

+ (void)fm_deleteObjectsWithCondition:(NSString *)condition databaseQueue:(FMDatabaseQueue *)databaseQueue {
    [databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSString *sql = [NSString deleteSQLWithTableName:tableName condition:condition];
        NSError *error = nil;
        [db executeUpdate:sql values:nil error:&error];
        if (error != nil) {
            CYLogSerious(@"DB: Failed to delete data, error: %@", error);
        }
    }];
}

+ (void)fm_deleteObjectsWithConditions:(NSDictionary *)conditions {
    FMDatabaseQueue *queue = [CYDatabaseStore defaultStore].databaseQueue;
    [[self class] fm_deleteObjectsWithConditions:conditions databaseQueue:queue];
}

+ (void)fm_deleteObjectsWithConditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue {
    [databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSArray *values = nil;
        NSString *sql = [NSString deleteSQLWithTableName:tableName conditions:conditions values:&values];
        NSError *error = nil;
        [db executeUpdate:sql values:values error:&error];
        if (error != nil) {
            CYLogSerious(@"DB: Failed to delete data, error: %@", error);
        }
    }];
}

+ (NSArray *)fm_syncQueryObjectsWithCondition:(NSString *)condition error:(NSError **)error {
    FMDatabase *database = [CYDatabaseStore defaultStore].database;
    return [[self class] fm_syncQueryObjectsWithCondition:condition database:database error:error];
}

+ (NSArray *)fm_syncQueryObjectsWithCondition:(NSString *)condition database:(FMDatabase *)database error:(NSError **)error {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    if (![database open]) {
        *error = [NSError errorWithDomain:@"com.cyl.database" code:-1 userInfo:@{ @"message": @"Failed to open db" }];
    } else {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSArray *values = nil;
        NSString *sql = [NSString querySQLWithTableName:tableName condition:condition];
        FMResultSet *rs = [database executeQuery:sql values:values error:error];
        if (error == nil) {
            while ([rs next]) {
                NSDictionary *attributes = [rs resultDictionary];
                id object = [[[self class] alloc] initWithAttributes:attributes];
                [results addObject:object];
            }
            [rs close];
        }
        
        [database close];
    }
    
    return results;
}

+ (NSArray *)fm_syncQueryObjectsWithConditions:(NSDictionary *)conditions error:(NSError **)error {
    FMDatabase *database = [CYDatabaseStore defaultStore].database;
    return [[self class] fm_syncQueryObjectsWithConditions:conditions database:database error:error];
}

+ (NSArray *)fm_syncQueryObjectsWithConditions:(NSDictionary *)conditions database:(FMDatabase *)database error:(NSError **)error {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    if (![database open]) {
        *error = [NSError errorWithDomain:@"com.cyl.database" code:-1 userInfo:@{ @"message": @"Failed to open db" }];
    } else {
        NSString *tableName = [CYDatabaseStore tableNameForKey:NSStringFromClass([self class])];
        NSArray *values = nil;
        NSString *sql = [NSString querySQLWithTableName:tableName conditions:conditions values:&values];
        FMResultSet *rs = [database executeQuery:sql values:values error:error];
        if (error == nil) {
            while ([rs next]) {
                NSDictionary *attributes = [rs resultDictionary];
                id object = [[[self class] alloc] initWithAttributes:attributes];
                [results addObject:object];
            }
            [rs close];
        }
        
        [database close];
    }
    
    return results;
}

@end
