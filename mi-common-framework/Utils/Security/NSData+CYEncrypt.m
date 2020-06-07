//
//  NSData+Encrypt.m
//  Demo
//
//  Created by Chen Yiliang on 7/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "NSData+CYEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@implementation NSData (CYEncrypt)

#pragma mark - DES/AES

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

#pragma mark - RAS

- (NSData *)RSAEncryptWithKey:(NSString *)publicKey {
    return [self RSAEncryptWithKey:publicKey isSign:NO];
}

- (NSData *)RSAEncryptWithKey:(NSString *)publicKey isSign:(BOOL)isSign {
    if (!publicKey) return nil;
    
    SecKeyRef keyRef = [[self class] getRSAPublicKeyRef:publicKey];
    if (!keyRef) return nil;
    
    const uint8_t *srcbuf = (const uint8_t *)[self bytes];
    size_t srclen = (size_t)self.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for (int idx = 0; idx < srclen; idx += src_block_size) {
        // NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if (data_len > src_block_size) {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        
        if (isSign) {
            status = SecKeyRawSign(keyRef,
                                   kSecPaddingPKCS1,
                                   srcbuf + idx,
                                   data_len,
                                   outbuf,
                                   &outlen
                                   );
        } else {
            status = SecKeyEncrypt(keyRef,
                                   kSecPaddingPKCS1,
                                   srcbuf + idx,
                                   data_len,
                                   outbuf,
                                   &outlen
                                   );
        }
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        } else {
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

- (NSData *)RSADecryptWithKey:(NSString *)privateKey {
    if (!privateKey) return nil;
    
    SecKeyRef keyRef = [[self class] getRSAPrivateKeyRef:privateKey];
    if (!keyRef) return nil;
    
    const uint8_t *srcbuf = (const uint8_t *)[self bytes];
    size_t srclen = (size_t)self.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx = 0; idx < srclen; idx += src_block_size) {
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if (data_len > src_block_size) {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        } else {
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for (int i = 0; i < outlen; i++) {
                if (outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero + 1] length:idxNextZero - idxFirstZero - 1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (SecKeyRef)getRSAPublicKeyRef:(NSString *)key {
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:0];
    data = [[self class] stripRSAPublicKeyHeader:data];
    if (!data) return nil;
    
    CFErrorRef error = NULL;
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    [attrs setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [attrs setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [attrs setObject:(__bridge id)kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    SecKeyRef keyRef = SecKeyCreateWithData((__bridge CFDataRef)data, (__bridge CFDictionaryRef)attrs, &error);
    if (error != NULL) {
        NSLog(@"SecKeyCreate fail. Error code: %ld", CFErrorGetCode(error));
    }
    return keyRef;
}

+ (SecKeyRef)addRSAPublicKey:(NSString *)key {
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:0];
    data = [[self class] stripRSAPublicKeyHeader:data];
    if (!data) return nil;

    //a tag to read/write keychain storage
    NSString *tag = @"RSA_PublicKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);

    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id)kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if (status != noErr) {
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripRSAPublicKeyHeader:(NSData *)d_key {
    // Skip ASN.1 public key header
    if (d_key == nil) return nil;
    
    unsigned long len = [d_key length];
    if (!len) return nil;
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int idx = 0;
    
    if (c_key[idx++] != 0x30) return nil;
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] = { 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return nil;
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return nil;
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return nil;
    
    // Now make a new NSData from this buffer
    return [NSData dataWithBytes:&c_key[idx] length:len - idx];
}

+ (SecKeyRef)getRSAPrivateKeyRef:(NSString *)key {
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if (spos.length > 0) {
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    } else {
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:0];
    data = [[self class] stripRSAPrivateKeyHeader:data];
    if (!data) return nil;
    
    CFErrorRef error = NULL;
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    [attrs setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [attrs setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [attrs setObject:(__bridge id)kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    SecKeyRef keyRef = SecKeyCreateWithData((__bridge CFDataRef)data, (__bridge CFDictionaryRef)attrs, &error);
    if (error != NULL) {
        NSLog(@"SecKeyCreate fail. Error code: %ld", CFErrorGetCode(error));
    }
    return keyRef;
}

+ (SecKeyRef)addRSAPrivateKey:(NSString *)key {
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if (spos.length > 0) {
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    } else {
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:0];
    data = [[self class] stripRSAPrivateKeyHeader:data];
    if (!data) return nil;

    //a tag to read/write keychain storage
    NSString *tag = @"RSA_PrivateKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);

    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id)kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)stripRSAPrivateKeyHeader:(NSData *)d_key {
    // Skip ASN.1 private key header
    if (d_key == nil) return nil;

    unsigned long len = [d_key length];
    if (!len) return nil;

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int idx = 22; //magic byte at offset 22

    if (0x04 != c_key[idx++]) return nil;

    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }

    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

@end
