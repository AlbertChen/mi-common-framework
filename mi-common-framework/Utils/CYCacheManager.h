//
//  CYCacheManager.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 7/22/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CYCacheManagerDidClearNotification;

@interface CYCacheManager : NSObject

+ (instancetype)defaultManager;

- (NSUInteger)getSize; // Unit is B
- (void)clear;

- (id)getJSONObjectWithFileName:(NSString *)fileName userID:(NSString *)userID;
- (void)saveJSONObject:(id)JSON withFileName:(NSString *)fileName userID:(NSString *)userID;

- (NSData *)getDataWithFileName:(NSString *)fileName userID:(NSString *)userID;
- (void)saveData:(NSData *)date withFileName:(NSString *)fileName userID:(NSString *)userID;

- (id<NSCoding>)getObjectWithClass:(Class)clazz userID:(NSString *)userID;
- (id<NSCoding>)getObjectWithFileName:(NSString *)fileName userID:(NSString *)userID;
- (void)saveObject:(id<NSCoding>)object userID:(NSString *)userID;
- (void)saveObject:(id<NSCoding>)object withFileName:(NSString *)fileName userID:(NSString *)userID;

- (void)removeItemWithFileName:(NSString *)fileName userID:(NSString *)userID;

@end
