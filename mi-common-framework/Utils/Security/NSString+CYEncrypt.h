//
//  NSString+Encrypt.h
//  Demo
//
//  Created by Chen Yiliang on 7/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYEncrypt)

/**
 * 求字符串的md5值
 *
 * @return 返回md5值
 */
- (NSString *)md5;

/**
 * DES加密字符串
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回加密后经Base64编码过的字符串
 */
- (NSString *)DESEncryptWithKey:(NSString *)key;
- (NSString *)DESEncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * DES解密Base64编码过的加密字符串
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回原始字符串
 */
- (NSString *)DESDecryptWithKey:(NSString *)key;
- (NSString *)DESDecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end
