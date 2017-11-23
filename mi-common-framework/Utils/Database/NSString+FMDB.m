//
//  NSString+FMDB.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "NSString+FMDB.h"

@implementation NSString (FMDB)

+ (NSString *)conditionString:(NSDictionary *)conditions values:(NSArray **)values {
    NSString *result = nil;
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
    if (conditions.count > 0) {
        __block NSMutableString *conditionString = nil;
        [conditions enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *field = nil;
            if (obj == [NSNull null]) {
                field = [NSString stringWithFormat:@"%@ is null", key];
            } else {
                field = [NSString stringWithFormat:@"%@=?", key];
                [valueArray addObject:obj];
            }
            
            if (conditionString == nil) {
                conditionString = [NSMutableString stringWithString:field];
            } else {
                [conditionString appendFormat:@" AND %@", field];
            }
        }];
        
        result = conditionString;
        *values = valueArray;
    }
    
    return result;
}

+ (NSString *)insertSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo values:(NSArray **)values {
    return [[self class] insertSQLWithTableName:tableName attributes:attributes userInfo:userInfo values:values allFields:nil];
}

+ (NSString *)insertSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo values:(NSArray **)values allFields:(NSArray *)allFields {
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", tableName];
    __block NSMutableString *fieldString = nil;
    __block NSMutableString *valueString = nil;
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:0];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (allFields == nil || [allFields containsObject:key]) {
            if (fieldString == nil) {
                fieldString = [NSMutableString stringWithString:key];
                valueString = [NSMutableString stringWithString:@"?"];
            } else {
                [fieldString appendFormat:@",%@", key];
                [valueString appendString:@",?"];
            }
            [valuesArray addObject:obj];
        }
    }];
    
    [userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (fieldString == nil) {
            fieldString = [NSMutableString stringWithString:key];
            valueString = [NSMutableString stringWithString:@"?"];
        } else {
            [fieldString appendFormat:@",%@", key];
            [valueString appendString:@",?"];
        }
        [valuesArray addObject:obj];
    }];
    
    [sql appendFormat:@" (%@) VALUES (%@)", fieldString, valueString];
    *values = valuesArray;
    
    return sql;
}

+ (NSString *)updateSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions values:(NSArray **)values {
    return [[self class] updateSQLWithTableName:tableName attributes:attributes conditions:conditions values:values allFields:nil];
}

+ (NSString *)updateSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions values:(NSArray **)values allFields:(NSArray *)allFields {
    if (attributes.count == 0) return nil;
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET", tableName];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:0];
    __block NSMutableString *fieldString = nil;
    [attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (allFields == nil || [allFields containsObject:key]) {
            if (fieldString == nil) {
                fieldString = [NSMutableString stringWithFormat:@"%@=?", key];
            } else {
                [fieldString appendFormat:@",%@=?", key];
            }
            [valuesArray addObject:obj];
        }
    }];
    [sql appendFormat:@" %@", fieldString];
    
    if (conditions.count > 0) {
        NSArray *conditionValues = nil;
        NSString *conditionString = [[self class] conditionString:conditions values:&conditionValues];
        [sql appendFormat:@" WHERE %@", conditionString];
        [valuesArray addObjectsFromArray:conditionValues];
    }
    
    *values = valuesArray;
    
    return sql;
}

+ (NSString *)deleteSQLWithTableName:(NSString *)tableName condition:(NSString *)condition {
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    if (condition.length > 0) {
        [sql appendFormat:@" WHERE %@", condition];
    }
    
    return sql;
}

+ (NSString *)deleteSQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions values:(NSArray **)values {
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:0];
    if (conditions.count > 0) {
        NSArray *conditionValues = nil;
        NSString *conditionString = [[self class] conditionString:conditions values:&conditionValues];
        [sql appendFormat:@" WHERE %@", conditionString];
        [valuesArray addObjectsFromArray:conditionValues];
    }
    
    *values = valuesArray;
    
    return sql;
}

+ (NSString *)querySQLWithTableName:(NSString *)tableName condition:(NSString *)condition {
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", tableName];
    if (condition.length > 0) {
        [sql appendFormat:@" WHERE %@", condition];
    }
    
    return sql;
}

+ (NSString *)querySQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions values:(NSArray *__autoreleasing *)values {
    NSAssert(tableName != nil && tableName.length > 0, @"Error: table name cannot be nil.");
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", tableName];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:0];
    if (conditions.count > 0) {
        NSArray *conditionValues = nil;
        NSString *conditionString = [[self class] conditionString:conditions values:&conditionValues];
        [sql appendFormat:@" WHERE %@", conditionString];
        [valuesArray addObjectsFromArray:conditionValues];
    }
    
    *values = valuesArray;
    
    return sql;
}

@end
