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
 * 求字符串的MD5值
 *
 * @return 返回MD5值
 */
- (NSString *)md5;

/**
* 求字符串的SHA256值
*
* @return 返回SHA256值
*/
- (NSString *)sha256;

/**
 * 3DES加密字符串
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回加密后经Base64编码过的字符串
 */
- (NSString *)DESEncryptWithKey:(NSString *)key;
- (NSString *)DESEncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * 3DES解密Base64编码过的加密字符串
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回原始字符串
 */
- (NSString *)DESDecryptWithKey:(NSString *)key;
- (NSString *)DESDecryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
* AES(256)加密字符串
* @param key   加密秘钥
* @param iv    加密偏移量
*
* @return 返回加密后经Base64编码过的字符串
*/
- (NSString *)AESEncryptWithKey:(NSString *)key;
- (NSString *)AESEncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * AES(256)解密Base64编码过的加密字符串
 * @param key   加密秘钥
 * @param iv    加密偏移量
 *
 * @return 返回原始字符串
 */
- (NSString *)AESDecryptWithKey:(NSString *)key;
- (NSString *)AESDecryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 * RSA加密字符串
 * @param publicKey 加密公钥
 * @param isSign 是否是数字签名
 *
 * @return 返回加密后经Base64编码过的字符串
 */
- (NSString *)RSAEncryptWithKey:(NSString *)publicKey;
- (NSString *)RSAEncryptWithKey:(NSString *)publicKey isSign:(BOOL)isSign;

/**
* RSA解密Base64编码过的加密字符串
* @param privateKey 加密私钥
*
* @return 返回原始字符串
*/
- (NSString *)RSADecryptWithKey:(NSString *)privateKey;

@end
