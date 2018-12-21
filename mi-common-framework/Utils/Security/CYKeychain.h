//
//  CYKeychain.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "STKeychain.h"

@interface CYKeychain : STKeychain

+ (NSString *)getPasswordForUsername:(NSString *)username error:(NSError **)error;
+ (BOOL)storeUsername:(NSString *)username andPassword:(NSString *)password error:(NSError **)error;
+ (BOOL)deleteItemForUsername:(NSString *)username error:(NSError **)error;

@end
