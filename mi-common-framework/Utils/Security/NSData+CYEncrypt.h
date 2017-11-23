//
//  NSData+Encrypt.h
//  Demo
//
//  Created by Chen Yiliang on 7/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CYEncrypt)

/**
 * DES加密二进制数据
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回加密后的二进制数据
 */
- (NSData *)DESEncryptWithKey:(NSString *)key;
- (NSData *)DESEncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * DES解密二进制数据
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回原始二进制数据
 */
- (NSData *)DESDecryptWithKey:(NSString *)key;
- (NSData *)DESDecryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * AES解密二进制数据
 * @param key 32位加密秘钥
 *
 * @return 返回原始二进制数据
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 * AES解密二进制数据
 * @param key 32位加密秘钥
 *
 * @return 返回原始二进制数据
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
