//
//  NSObject+CertificateManager.h
//  GroupAppOne
//
//  Created by INBEOM on 2018. 4. 20..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FidoTransaction.h"
#import <IntergratedCertification/IntergratedCertification.h>

/** Certificate Manage Type */
typedef enum CertificateCommand {
    CertificateManageCommandTypeAuth,               // 인증
    CertificateManageCommandTypeRegist,             // 가입
    CertificateManageCommandTypeSearchPassword,      // 비밀번호 찾기
    CertificateManageCommandTypeSearchPassword2,      // 비밀번호 찾기 Step2
} CertificateManageCommandType;

@protocol CertificateDelegate;

@interface CertificateManager:NSObject<FidoTransactionDelegate,UIAlertViewDelegate>

@property (assign, nonatomic) id<CertificateDelegate> delegate;
@property (assign, nonatomic) NSDictionary* resulticData;
@property(nonatomic,strong) NSString* verifyType;
@property (assign, nonatomic) BOOL resultCode;
@property (assign, nonatomic) CertificateManageCommandType commendType;

- (id)initWithDelegate:(id)delegate;
-(void)requestVerify:(FidoVerifyType)verifyType;

//등록 시 icData Validation
+(void)checkicDataRegist:(NSDictionary*)icData setCommand:(CertificateManageCommandType)commandType;
//인증 시 icData Validation
+(BOOL)checkicDataAuth:(NSDictionary*)icData;
//Fido 요청 시 Validation
+(void)checkRequestFido:(FidoTransaction*)fidoTransaction;

@end

@protocol CertificateDelegate <NSObject>
@optional

//결과********************** 테스트용. 사용안함.
- (void)CertificateResult:(CertificateManager*)certificate;
- (void)updateicData:(FidoTransaction*)fidoTransaction ; 

@end
