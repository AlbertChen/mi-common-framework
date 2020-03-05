//
//  NSData+Encrypt.m
//  Demo
//
//  Created by Chen Yiliang on 7/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "NSData+CYEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (CYEncrypt)

- (NSData *)DESEncryptWithKey:(NSString *)key {
    return [self DESEncryptWithKey:key iv:nil];
}

- (NSData *)DESEncryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self encryptWithAlgorithm:kCCAlgorithm3DES key:key keySize:kCCKeySize3DES blockSize:kCCBlockSize3DES iv:iv];
}

- (NSData *)DESDecryptWithKey:(NSString *)key {
    return [self DESDecryptWithKey:key iv:nil];
}

- (NSData *)DESDecryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self decryptWithAlgorithm:kCCAlgorithm3DES key:key keySize:kCCKeySize3DES blockSize:kCCBlockSize3DES iv:iv];
}

- (NSData *)AESEncryptWithKey:(NSString *)key {
    return [self AESEncryptWithKey:key iv:nil];
}

- (NSData *)AESEncryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self encryptWithAlgorithm:kCCAlgorithmAES key:key keySize:kCCKeySizeAES256 blockSize:kCCBlockSizeAES128 iv:iv];
}

- (NSData *)AESDecryptWithKey:(NSString *)key {
    return [self AESDecryptWithKey:key iv:nil];
}

- (NSData *)AESDecryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self decryptWithAlgorithm:kCCAlgorithmAES key:key keySize:kCCKeySizeAES256 blockSize:kCCBlockSizeAES128 iv:iv];
}

- (NSData *)encryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize iv:(NSString *)iv {
    size_t bufferSize = [self length];
    const void *vplainText = (const void *)[self bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (bufferSize + blockSize) & ~(blockSize - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vIv = iv == nil ? NULL : (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       algorithm,
                       kCCOptionPKCS7Padding,
                       vkey,
                       keySize,
                       vIv,
                       vplainText,
                       bufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *encryptData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return encryptData;
}

- (NSData *)decryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize iv:(NSString *)iv {
    size_t bufferSize = [self length];
    const void *vplainText = [self bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (bufferSize + blockSize) & ~(blockSize - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vIv = iv == nil ? NULL : (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       algorithm,
                       kCCOptionPKCS7Padding,
                       vkey,
                       keySize,
                       vIv,
                       vplainText,
                       bufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *decryptData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return decryptData;
}

@end
