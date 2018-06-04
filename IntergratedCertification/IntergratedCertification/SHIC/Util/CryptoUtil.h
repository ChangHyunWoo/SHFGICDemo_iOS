//
//  Crypto.h
//  ShinhanBank
//
//  Created by khson on 2017. 11. 10..
//  Copyright © 2017년 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

// Hash 알고리즘
typedef enum {
    Hash_MD2,
    Hash_MD4,
    Hash_MD5,
    Hash_SHA1,
    Hash_SHA256,
    Hash_SHA512,
} HashAlg;

// 암호화 알고리즘
typedef enum {
    Crypto_AES128,
    Crypto_AES256
} CryptoAlg;

// 암호화 운영 모드와 패딩
typedef enum {
    MODE_CBC_PKCS7Padding,
    MODE_ECB_PKCS7Padding
} CryptoMode;

/**
 암호화 기능을 정의합니다.
 
 @details
     (기능 1.) 각종 Hash(MD2, MD4, MD5, SHA1, SHA256, SHA512)를 제공합니다. <br/>
     (기능 2.) AES128 Encrypt, Decrypt 를 제공합니다. <br/>
 @since 1.0.0
 @date 2017.11.10
 */
@interface CryptoUtil : NSObject

// MARK: - Hash Methods (Public)
/**
 Hash를 반환합니다.

 @since 1.0.0
 @param data 대상 데이터
 @param hashAlg (Hash) 알고리즘
 @return Hash Data
 */
+ (NSData *)getHash:(NSData *)data hashAlg:(HashAlg)hashAlg;


/**
 NSData(byte array)를 hex string 형태로 반환합니다.

 @details 1byte를 16진수 문자열로 표시합니다. <br/>
     16진수 표현을 위해 (2byte)로 반환됩니다. <br/>s
 @since 1.0.0
 @param data NSData(byte array)
 @return hex 문자열
 */
+ (NSString *)hexString:(NSData *)data;

// MARK: - Crypto Methods (Public)
/**
 입력받은 데이터를 AES128로 암호화 합니다.

 @details 128bit의 AES알고리즘으로 ECB 운영모드, PKCS7 패딩을 적용합니다.
 @since 1.0.0
 @param key 암호화 키
 @param Data 암호화 대상 데이터
 @return 암호화 결과 데이터
 */
+ (NSData *)AES128EncryptWithKey:(NSString *)key data:(NSData *)Data;

/**
 AES128 로 암호화 된 데이터를 복호화 합니다.

 @details 128bit의 AES알고리즘으로 ECB 운영모드, PKCS7 패딩을 적용합니다.
 @since 1.0.0
 @param key 복호화 키
 @param Data 복호화 대상 데이터
 @return 복호화 결과 데이터 
 */
+ (NSData *)AES128DecryptWithKey:(NSString *)key encData:(NSData *)Data;


@end
