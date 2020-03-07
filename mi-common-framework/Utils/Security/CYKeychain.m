//
//  CYKeychain.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYKeychain.h"
#import <Security/Security.h>

NSString * const CYKeychainErrorDomain = @"com.cyl.keychain";
NSString * const CYKeychainErrorMessageKey = @"message";
NSString * const CYKeychainErrorSecCodeKey = @"secCode";

#define CYKeychainServiceName   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@implementation CYKeychain

+ (NSString *)getPasswordWithAccount:(NSString *)account error:(NSError **)error {
    if (!account) {
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeInvalidParams
                                 userInfo:@{ CYKeychainErrorMessageKey: @"invalid parameters" }];
        return nil;
    }
    
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    [attrs setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrService];
    [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrLabel];
    [attrs setObject:account forKey:(__bridge id)kSecAttrAccount];
    [attrs setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
    CFDataRef resultData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attrs, (CFTypeRef *)&resultData);
    if (status == errSecItemNotFound) {
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeNotFound
                                 userInfo:@{ CYKeychainErrorMessageKey: @"not found" }];
        return nil;
    }
    if(status != noErr){
        NSDictionary *userInfo = @{ CYKeychainErrorSecCodeKey: @(status),
                                    CYKeychainErrorMessageKey: @"operation failed" };
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeOperationFailed
                                 userInfo:userInfo];
        return nil;
    }
    
    NSString *password = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(resultData) encoding:NSUTF8StringEncoding];
    CFRelease(resultData);
    return password;
}

+ (BOOL)addPasswork:(NSString *)passwork withAccount:(NSString *)account error:(NSError **)error {
    if (!passwork || !account) {
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeInvalidParams
                                 userInfo:@{ CYKeychainErrorMessageKey: @"invalid parameters" }];
        return NO;
    }
    
    NSError *getError = nil;
    NSString *savedPassword = [self getPasswordWithAccount:account error:&getError];
    if (getError.code == CYKeychainErrorCodeOperationFailed) {
        *error = getError;
        return NO;
    }
    
    OSStatus status = noErr;
    if (savedPassword) {
        if (![savedPassword isEqualToString:passwork]) {
            NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
            [attrs setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
            [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrService];
            [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrLabel];
            [attrs setObject:account forKey:(__bridge id)kSecAttrAccount];
            
            NSMutableDictionary *updateAttrs = [[NSMutableDictionary alloc] init];
            [updateAttrs setObject:[passwork dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
            
            status = SecItemUpdate((__bridge CFDictionaryRef)attrs, (__bridge CFDictionaryRef)updateAttrs);
        }
    } else {
        NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
        [attrs setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrService];
        [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrLabel];
        [attrs setObject:account forKey:(__bridge id)kSecAttrAccount];
        [attrs setObject:[passwork dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)attrs, NULL);
    }
    
    if (status != noErr) {
        NSDictionary *userInfo = @{ CYKeychainErrorSecCodeKey: @(status),
                                    CYKeychainErrorMessageKey: @"operation failed" };
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeOperationFailed
                                 userInfo:userInfo];
        return NO;
    }
    return YES;
}

+ (BOOL)deletePasswordWithAccount:(NSString *)account error:(NSError **)error {
    if (!account) {
        *error = [NSError errorWithDomain:CYKeychainErrorDomain code:CYKeychainErrorCodeInvalidParams userInfo:nil];
        return NO;
    }
    
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    [attrs setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrService];
    [attrs setObject:CYKeychainServiceName forKey:(__bridge id)kSecAttrLabel];
    [attrs setObject:account forKey:(__bridge id)kSecAttrAccount];
    [attrs setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnAttributes];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)attrs);
    if(status != noErr){
        NSDictionary *userInfo = @{ CYKeychainErrorSecCodeKey: @(status),
                                    CYKeychainErrorMessageKey: @"operation failed" };
        *error = [NSError errorWithDomain:CYKeychainErrorDomain
                                     code:CYKeychainErrorCodeOperationFailed
                                 userInfo:userInfo];
        return NO;
    }
    return YES;
}

@end
