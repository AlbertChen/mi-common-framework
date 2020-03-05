//
//  NSString+Encrypt.m
//  Demo
//
//  Created by Chen Yiliang on 7/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "NSString+CYEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+CYEncrypt.h"

@implementation NSString (CYEncrypt)

- (NSString *)md5 {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    return ret;
}

- (NSString *)sha256 {
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    return ret;
}

#pragma mark - DES

- (NSString *)DESEncryptWithKey:(NSString *)key {
    return [self DESEncryptWithKey:key iv:nil];
}

- (NSString *)DESEncryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data DESEncryptWithKey:key iv:iv];
    NSString *result = [encryptData base64EncodedStringWithOptions:0];
    return result;
}

- (NSString *)DESDecryptWithKey:(NSString *)key {
    return [self DESDecryptWithKey:key iv:nil];
}

- (NSString *)DESDecryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptData = [encryptData DESDecryptWithKey:key iv:iv];
    NSString *result = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - AES

- (NSString *)AESEncryptWithKey:(NSString *)key {
    return [self AESEncryptWithKey:key iv:nil];
}

- (NSString *)AESEncryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AESEncryptWithKey:key iv:iv];
    NSString *result = [encryptData base64EncodedStringWithOptions:0];
    return result;
}

- (NSString *)AESDecryptWithKey:(NSString *)key {
    return [self AESDecryptWithKey:key iv:nil];
}

- (NSString *)AESDecryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptData = [encryptData AESDecryptWithKey:key iv:iv];
    NSString *result = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - RSA

- (NSString *)RSAEncryptWithKey:(NSString *)publicKey {
    return [self RSAEncryptWithKey:publicKey isSign:NO];
}

- (NSString *)RSAEncryptWithKey:(NSString *)publicKey isSign:(BOOL)isSign {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data RSAEncryptWithKey:publicKey isSign:isSign];
    NSString *result = [encryptData base64EncodedStringWithOptions:0];
    return result;
}

- (NSString *)RSADecryptWithKey:(NSString *)privateKey {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptData = [encryptData RSADecryptWithKey:privateKey];
    NSString *result = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return result;
}

@end
