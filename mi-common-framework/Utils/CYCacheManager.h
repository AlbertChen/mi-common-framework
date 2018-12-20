//
//  CYCacheManager.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 7/22/16.
//  Copyright © 2016 CYYUN. All rights reserved.
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

@end
