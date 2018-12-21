//
//  NSString+FMDB.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FMDB)

+ (NSString *)conditionString:(NSDictionary *)conditions values:(NSArray **)values;

+ (NSString *)insertSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo values:(NSArray **)values;
+ (NSString *)insertSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo values:(NSArray **)values allFields:(NSArray *)allFields;

+ (NSString *)updateSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions values:(NSArray **)values;
+ (NSString *)updateSQLWithTableName:(NSString *)tableName attributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions values:(NSArray **)values allFields:(NSArray *)allFields;

+ (NSString *)deleteSQLWithTableName:(NSString *)tableName condition:(NSString *)condition;
+ (NSString *)deleteSQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions values:(NSArray **)values;

+ (NSString *)querySQLWithTableName:(NSString *)tableName condition:(NSString *)condition;
+ (NSString *)querySQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions values:(NSArray **)values;

@end
