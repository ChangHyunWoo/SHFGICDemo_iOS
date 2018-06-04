//
//  Crypto.m
//  ShinhanBank
//
//  Created by khson on 2017. 11. 10..
//  Copyright © 2017년 finger. All rights reserved.
//

#import "CryptoUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define VALIDATION(v) if(!v) return nil;

@implementation CryptoUtil

#pragma mark - Hash Methods (Public)
+ (NSData *)getHash:(NSData *)data hashAlg:(HashAlg)hashAlg {
    VALIDATION(data);
    NSData *result = nil;
    switch (hashAlg) {
        case Hash_MD2:      result = [CryptoUtil md2:data];     break;
        case Hash_MD4:      result = [CryptoUtil md4:data];     break;
        case Hash_MD5:      result = [CryptoUtil md5:data];     break;
        case Hash_SHA1:     result = [CryptoUtil sha1:data];    break;
        case Hash_SHA256:   result = [CryptoUtil sha256:data];  break;
        case Hash_SHA512:   result = [CryptoUtil sha512:data];  break;
        default: break;
    }
    return result;
}

+ (NSString *)hexString:(NSData *)data {
    VALIDATION(data);
    NSString *str = [data description];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    return str;
}

#pragma mark - Hash Methods (Private)
+ (NSData *)md2:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_MD2_DIGEST_LENGTH] = {0};
    CC_MD2(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_MD2_DIGEST_LENGTH] : nil;
}

+ (NSData *)md4:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_MD4_DIGEST_LENGTH] = {0};
    CC_MD4(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_MD4_DIGEST_LENGTH] : nil;
}

+ (NSData *)md5:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH] : nil;
}

+ (NSData *)sha1:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    CC_SHA1(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH] : nil;
}

+ (NSData *)sha256:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH] : nil;
}

+ (NSData *)sha512:(NSData *)data {
    VALIDATION(data);
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(data.bytes, (int)data.length, digest);
    return data.length > 0 ? [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH] : nil;
}

#pragma mark - Crypto Methods (Public)
+ (NSData *)AES128EncryptWithKey:(NSString *)key data:(NSData *)Data {
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode + kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          nil, /* initialization vector (optional) */
                                          [Data bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        free(buffer); //free the buffer;
        return nil;
    }
}

+ (NSData *)AES128DecryptWithKey:(NSString *)key encData:(NSData *)Data {
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode + kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [Data bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    } else {
        free(buffer); //free the buffer;
        return nil;
    }
}

@end
