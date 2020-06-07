//
//  CYKeychain.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CYKeychainErrorDomain;
extern NSString * const CYKeychainErrorMessageKey;
extern NSString * const CYKeychainErrorSecCodeKey;

typedef NS_ENUM(NSInteger, CYKeychainErrorCode) {
    CYKeychainErrorCodeNotFound = -1998,
    CYKeychainErrorCodeInvalidParams = -1999,
    CYKeychainErrorCodeOperationFailed = -2000,
};

@interface CYKeychain : NSObject

+ (NSString *)getPasswordWithAccount:(NSString *)account error:(NSError **)error;
// Add or Update
+ (BOOL)storePassword:(NSString *)passwork withAccount:(NSString *)account error:(NSError **)error;
+ (BOOL)deletePasswordWithAccount:(NSString *)account error:(NSError **)error;

@end
