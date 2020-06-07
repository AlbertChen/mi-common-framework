//
//  CYDataModel+FMDB.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYDataModel.h"
#import "FMDB.h"

@interface CYDataModel (FMDB)

- (void)fm_updateObjectWithKey:(NSString *)key;
- (void)fm_updateObjectWithKey:(NSString *)key databaseQueue:(FMDatabaseQueue *)databaseQueue;

- (void)fm_updateObjectWithConditions:(NSDictionary *)conditions;
- (void)fm_updateObjectWithConditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (void)fm_insertObjectWithAttributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo;
+ (void)fm_insertObjectWithAttributes:(NSDictionary *)attributes userInfo:(NSDictionary *)userInfo databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (void)fm_insertObjectsWithAttributesArray:(NSArray *)attributesArray userInfo:(NSDictionary *)userInfo;
+ (void)fm_insertObjectsWithAttributesArray:(NSArray *)attributesArray userInfo:(NSDictionary *)userInfo databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (void)fm_updateObjectsWithAttributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions;
+ (void)fm_updateObjectsWithAttributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (void)fm_deleteObjectsWithCondition:(NSString *)condition;
+ (void)fm_deleteObjectsWithCondition:(NSString *)condition databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (void)fm_deleteObjectsWithConditions:(NSDictionary *)conditions;
+ (void)fm_deleteObjectsWithConditions:(NSDictionary *)conditions databaseQueue:(FMDatabaseQueue *)databaseQueue;

+ (NSArray *)fm_syncQueryObjectsWithCondition:(NSString *)condition error:(NSError **)error;
+ (NSArray *)fm_syncQueryObjectsWithCondition:(NSString *)condition database:(FMDatabase *)database error:(NSError **)error;

+ (NSArray *)fm_syncQueryObjectsWithConditions:(NSDictionary *)conditions error:(NSError **)error;
+ (NSArray *)fm_syncQueryObjectsWithConditions:(NSDictionary *)conditions database:(FMDatabase *)database error:(NSError **)error;

@end
