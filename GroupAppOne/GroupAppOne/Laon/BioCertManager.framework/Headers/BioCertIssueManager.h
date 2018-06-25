//
//  BioCertIssueManager.h
//  public_onepass
//
//  Created by Eliot Choi on 2017. 4. 12..
//  Copyright © 2017년 라온시큐어_이민수. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BioCertIssueManager : NSObject

@property (nonatomic, retain) NSString *certificateHash;
@property (nonatomic, retain) NSString *userCertificateBase64;

//update
@property (nonatomic, retain) NSString *oldPukHash;
@property (nonatomic, retain) NSData *oldCertPin;
//@property (nonatomic, retain) NSString *oldServerNonce;


- (void)createKeyPairWithCompletion:(void (^ __nullable)(int result_code, NSString *result_message)) completion;
- (NSData *)getPopoSign;
- (int)issueBioCertificateWithCAIp:(NSString *)caIp caPort:(NSString *)caPort caCode:(NSString *)caCode popoSignData:(NSData *)popoSignData refNum:(NSString*)refNum authCode:(NSString *)authCode;
- (NSString *)publicKeyHash;
- (NSString *)pkcs8PrivateKeyForPassword:(NSData *)passwordData;


//update
- (void)setPkiMessageWithCompletion:( NSString *) caIp caPort:(NSString *)caPort caCode:(NSString *)caCode oldCertBase64:(NSString*)oldCertBase64 completion:(void (^ __nullable)(int result_code, NSString * _Nonnull result_message)) completion;
- (void)setPopoSignWithCompletion:(NSString*)encryptedPrivateKeyBase64 oldPrivateKeyPwdData:(NSData*)oldPrivateKeyPwdData completion:(void (^ __nullable)(int result_code, NSString * _Nonnull result_message)) completion;
-(void) setUpdatedCert;
-(void)completeBioCertUpdate;
-(NSString*)returnKSWCMPErrorMsg;
-(NSString *)getVersion;

@end
