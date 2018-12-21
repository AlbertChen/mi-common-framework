//
//  CYKeychain.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYKeychain.h"

#define SERVICE_NAME    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@implementation CYKeychain

+ (NSString *)getPasswordForUsername:(NSString *)username error:(NSError **)error {
    return [self getPasswordForUsername:username andServiceName:SERVICE_NAME error:error];
}

+ (BOOL)storeUsername:(NSString *)username andPassword:(NSString *)password error:(NSError **)error {
    return [self storeUsername:username andPassword:password forServiceName:SERVICE_NAME updateExisting:YES error:error];
}

+ (BOOL)deleteItemForUsername:(NSString *)username error:(NSError **)error {
    return [self deleteItemForUsername:username andServiceName:SERVICE_NAME error:error];
}

@end
