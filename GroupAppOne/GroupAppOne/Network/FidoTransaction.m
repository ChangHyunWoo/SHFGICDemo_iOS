//
//  FidoTransaction.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 3. 5..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>

#import <public_onepass/OnePassManager.h>
#import <public_onepass/OnePassDefine.h>
#import "FidoTransaction.h"
#import "AppDelegate.h"

#import "CryptoUtil.h"
#import "NSData+Base64.h"

@interface FidoTransaction  () <OnePassMangerAppDelegate>
{
    NSString* icID;
    NSString* trID;
}
@end

@implementation FidoTransaction
//초기화
- (id)init
{
    self = [super init];
    if (self) {
        icID = nil;
        trID = nil;
        self.rtnOnepassCode = -9999;
    }

    [D_CA showLoading];

    return self;
}

// ================== 사용자 유효성 검증
-(void)verifyCertification:(NSString*)ciOrIcid type:(FidoVerifyType)type
{
    OnePassManager* onePassManager = [OnePassManager sharedSingleton];

    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/verifyShic"];

    //=========== 고객 번호(CI) =============
    // (요청 별로 icId | ciNo 분기처리)
    if(type ==FidoVerifyAuth || type == FidoVerifyPasswordChangeAuth){
        [tr putValue:ciOrIcid forBody:@"icId"];
    }
    else{
        [tr putValue:ciOrIcid forBody:@"ciNo"];
    }

    //=========== 요청구분 ===========
    [tr putValue:@"checkRegisteredStatus" forBody:@"command"];

    //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
    [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
    [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
    [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
    [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif
    //=========== 디바이스/앱 ID ===========
    [tr putValue:onePassManager.deviceId forBody:@"deviceId"];
    [tr putValue:onePassManager.facetId forBody:@"appId"];

    //=========== 인증장치 타입 ============
    //  (변경 된 다른 코드 보내기 위해)
    if(_verifyType)
        [tr putValue:_verifyType forBody:@"verifyType"];
    else
        [tr putValue:SERVERCODE_VERIFYTYPE_PIN forBody:@"verifyType"];
    
//    if(type == FidoVerifyRegist)
//        [tr putValue:@"1" forBody:@"requestType"];
//    else if(type == FidoVerifyAuth)
//        [tr putValue:@"2" forBody:@"requestType"];

    //=========== 업무 구분 ===========
    //  (변경 된 다른 코드 보내기 위해)
    if(_requestType)
        [tr putValue:_requestType forBody:@"requestType"]; //등록
    else{
        NSString* requestType = [NSString stringWithFormat:@"%ld", (long)type];
        [tr putValue:requestType forBody:@"requestType"];
    }
    
    [tr transmitWithFinished:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSMutableDictionary * resultDict = tr.response;
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
        
        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            self.rtnicData=resultDict[@"dataBody"][@"icData"];

            //======================= 화면에 인증서 정보를 업데이트가 필요 시 해당 함수 콜백.
            if([self.delegate respondsToSelector:@selector(updateicData:)]){
                [self.delegate updateicData:self];
            }

            //======================= 인증서 정보 콜백.
            if( [self.delegate respondsToSelector:@selector(verifyResult:message:data:)] )
                [self.delegate verifyResult:YES message:resultDict[@"dataBody"][@"resultMsg"] data: resultDict[@"dataBody"]];
            //[self.delegate inquireResult:YES message:resultDict[@"dataBody"][@"resultMsg"] data: nil];
            
        }//Error 처리
        else{
            if( [self.delegate respondsToSelector:@selector(verifyResult:message:data:)] )
                [self.delegate verifyResult:NO message:resultDict[@"dataBody"][@"resultMsg"] data: nil];
        }
        
    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];
        if( [self.delegate respondsToSelector:@selector(verifyResult:message:data:)] )
            [self.delegate verifyResult:NO message:errMsg data:nil];
        
    } cancel:^(SHICTransaction *tr) {
    }];

}

//=============== 인증서 조회
-(void)inquireCertification:(NSString*)icid
{
    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/listShic"];

    //=========== 고객 번호(ic) =============
    [tr putValue:icid forBody:@"icId"];

    [tr transmitWithFinished:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSMutableDictionary * resultDict = tr.response;
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            self.isOK=YES;
        }//Error 처리
        else{
            self.isOK=NO;
        }

        self.rtnResultCode=resultCode;
        self.rtnicData = resultDict[@"dataBody"][@"icData"];
        self.rtnMsg = resultDict[@"dataBody"][@"resultMsg"];
        self.rtnResultData = resultDict[@"dataBody"][@"resultData"];

        if([self.delegate respondsToSelector:@selector(inquireResult:)])
            [self.delegate inquireResult:self];

    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];

        self.isOK=NO;
        self.rtnMsg = errMsg;

        if( [self.delegate respondsToSelector:@selector(inquireResult:)] )
            [self.delegate inquireResult:self];
        
    } cancel:^(SHICTransaction *tr) {
        [D_CA hideLoading];
    }];
}
//============= PIN유효성 체크
-(void)requestPinCheck:(NSString*)pin{

    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/checkPinRule"];
    //[tr putValue:@"requestServiceRegist" forBody:@"command"];

    //=========== 간편비밀번호 ===========
    [tr putValue:pin forBody:@"pinPwd"];
    
    [tr transmitWithFinished:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSMutableDictionary * resultDict = tr.response;
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            self.isOK=YES;
            self.rtnResultCode=resultCode;
            self.rtnicData = resultDict[@"dataBody"][@"icData"];
            self.rtnMsg = resultDict[@"dataBody"][@"resultMsg"];
            self.rtnResultData = resultDict[@"dataBody"][@"resultData"];

            if( [self.delegate respondsToSelector:@selector(pinCheckResult:message:data:)] )
                [self.delegate pinCheckResult:YES message:resultDict[@"dataBody"][@"resultMsg"] data: nil];

        }//Error 처리
        else{
            self.isOK=NO;
            self.rtnResultCode=resultCode;
            self.rtnicData = resultDict[@"dataBody"][@"icData"];
            self.rtnMsg = resultDict[@"dataBody"][@"resultMsg"];
            self.rtnResultData = resultDict[@"dataBody"][@"resultData"];

            if( [self.delegate respondsToSelector:@selector(pinCheckResult:message:data:)] )
                [self.delegate pinCheckResult:NO message:resultDict[@"dataBody"][@"resultMsg"] data: nil];
        }
        
        // 일반적인 에러인경우
    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];
        if( [self.delegate respondsToSelector:@selector(pinCheckResult:message:data:)] )
            [self.delegate pinCheckResult:NO message:errMsg data:nil];
        
    } cancel:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"cancel");
        if( [self.delegate respondsToSelector:@selector(pinCheckResult:message:data:)] )
            [self.delegate pinCheckResult:NO message:@"PIN번호 체크에 실패하였습니다." data:nil];
    }];

}

//============================ 등록|인증|재등록|수정 등 준비요청
-(void)requestFido:(FidoCommandType)commandType
{
    OnePassManager* onePassManager = [OnePassManager sharedSingleton];
    
    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/requestFido"];

    //Return Instance Value ( 요청 했던 command Type을 반환)
    self.cmdType=commandType;
    
    /**********************************************************************
     * Parameter Set *
     * 가입 (100) | 재가입 (103)
     * 등록 (101) | 재등록 (104)
     * 지문등록 (111)
     **********************************************************************/
    if(commandType == FidoCommandForUserFingerRegistSend || commandType == FidoCommandForUserRegist
       || commandType == FidoCommandForUserRe_Regist || commandType == FidoCommandForUserJoin || commandType == FidoCommandForUserRejoin
       ){
        tr.code =@"requestServiceRegist";

        //=========== 요청구분 ===========
        [tr putValue:@"requestServiceRegist" forBody:@"command"];

        //=========== 요청자구분 ===========
        [tr putValue:@"app" forBody:@"bizReqType"];
        
        //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
        [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
        [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif
        //=========== 디바이스/앱 ID ===========
        [tr putValue:onePassManager.deviceId forBody:@"deviceId"];
        [tr putValue:onePassManager.facetId forBody:@"appId"];
        
        //=========== 인증장치 타입 ===========
        // 지문 2, Pin 512
        [tr putValue:_verifyType forBody:@"verifyType"];
        
        //=========== 고객 번호(CI) =============
        [tr putValue:[[SHICUser defaultUser] get:KEY_CI] forBody:@"ciNo"];
        NSLog(@"CI = %@",[[SHICUser defaultUser] get:KEY_CI]);
    
        //=========== 고객 실명 =============
        [tr putValue:[[SHICUser defaultUser] get:KEY_NAME] forBody:@"realNm"];
        NSLog(@"고객실명 = %@",[[SHICUser defaultUser] get:KEY_NAME]);
        
        //=========== OS Type ===========
        ////안드로이드 1, 아이폰 2
        [tr putValue:@"2" forBody:@"osType"];
        
        //=========== 등록구분 ===========
        //가입 또는 재가입(해지후)
        if(commandType == FidoCommandForUserJoin || commandType == FidoCommandForUserRejoin){
            NSLog(@"\n■■■■■■■■■■■■■■■■■■■■ 서비스가입 또는 재가입 ■■■■■■■■■■■■■■■■■■■■\n");
            //=========== 통합 ID ===========
            if(commandType == FidoCommandForUserRejoin)
                [tr putValue: [[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
            
            if(commandType == FidoCommandForUserJoin && [_verifyType isEqualToString:SERVERCODE_VERIFYTYPE_FIDO])
                [tr putValue: [[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
            
            //=========== 간편비밀번호 ===========
            [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword1]  forBody:@"pinPwd"];
            [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword2]  forBody:@"pinPwdCheck"];
        }
        // 가입또는 등록시에 핀등록만 하고 나중에 지문등록하려고 하는경우
        else if(commandType == FidoCommandForUserFingerRegistSend){ //지문등록
            NSLog(@"\n■■■■■■■■■■■■■■■■■■■■ 지문등록 ■■■■■■■■■■■■■■■■■■■■\n");
            //=========== 통합 ID ===========
            [tr putValue: [[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
        }
        //등록 또는 재등록(정지후)
        else if(commandType == FidoCommandForUserRegist || commandType == FidoCommandForUserRe_Regist){
            NSLog(@"\n■■■■■■■■■■■■■■■■■■■■ 등록 또는 재등록 ■■■■■■■■■■■■■■■■■■■■\n");
            //=========== 통합 ID ===========
            [tr putValue: [[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
            NSLog(@"ICID = %@",[[SHICUser defaultUser] get:KEY_ICID]);

            //=========== 간편비밀번호 ===========
            [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword1]  forBody:@"pinPwd"];
        }
        //=========== 업무 구분 ===========
        _requestType = [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"]];
        [tr putValue:_requestType forBody:@"requestType"]; //등록
        NSLog(@"%@",tr.requestBody);
        NSLog(@"\n■■■■■■■■■■■■■■■■■■■■  ■■■■■■■■  ■■■■■■■■  ■■■■■■■■■■■■■■■■■■■■\n");
    }
    /**********************************************************************
     * Parameter Set *
     * 핀,지문 인증 (200) | 지문등록 인증 (110) | QR인증 (201) | SSO인증(203)
     **********************************************************************/
    else if(commandType == FidoCommandForUserAuth || commandType == FidoCommandForUserFingerRegistAuth
            || commandType == FidoCommandForUserQRAuth
            || commandType == FidoCommandForUserSSOAuth
            ){
        tr.code =@"requestServiceAuth";

        //=========== 요청구분 ===========
        [tr putValue:@"requestServiceAuth" forBody:@"command"];
       
        //=========== 요청자구분 ===========
        [tr putValue:@"app" forBody:@"bizReqType"];

        //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
        [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
        [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif

        //================= QR 코드 인증시 QR에서 인식한 svcTrid Set ==================
        if(commandType == FidoCommandForUserQRAuth){
            [tr putValue:D_CD.sendQRData forBody:@"svcTrId"];
        }

        //=========== 디바이스/앱 ID ===========
        [tr putValue:onePassManager.deviceId forBody:@"deviceId"];
        [tr putValue:onePassManager.facetId forBody:@"appId"];
        
        //=========== 인증장치 타입 ===========
        // 지문 2, Pin 512
        [tr putValue:_verifyType forBody:@"verifyType"];

        //=========== 통합 ID ===========
//        [tr putValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGING_ICID"] forBody:@"icId"];
//        NSLog(@"통합 ID =  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGING_ICID"]);
        [tr putValue:[[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
        NSLog(@"통합 ID =  %@",[[SHICUser defaultUser] get:KEY_ICID]);

        //=========== 간편비밀번호 ===========
        if([_verifyType isEqualToString:SERVERCODE_VERIFYTYPE_PIN]){

            //================= SSO(203) 인증 시 ssoData = Pinpwd
            if(commandType == FidoCommandForUserSSOAuth){
                [tr putValue:self.affiliatesCode  forBody:@"affiliatesCode"];
                [tr putValue:self.ssoData  forBody:@"ssoData"];
            }
            else{
                [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword1]  forBody:@"pinPwd"];
            }
        }

        //=========== 업무 구분 ===========
        _requestType = [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"]];
        [tr putValue:_requestType forBody:@"requestType"]; //인증

        //=========== 간편비밀번호2 (비밀번호 변경 시 (601) )  ===========
        if([_requestType isEqualToString:[NSString stringWithFormat:@"%d",FidoCommandForPasswordChange]]){
            [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword2]  forBody:@"pinPwdCheck"];
        }
    }
    /**********************************************************************
     * Parameter Set *
     * 해지 (300) | 정지 (301)
     **********************************************************************/
    else if(commandType == FidoCommandForUserRelease || commandType == FidoCommandForUserPause){
//        tr.code =@"requestServiceRelease";
        tr.code =@"requestServiceAuth";

        //=========== 요청구분 ===========
        [tr putValue:@"requestServiceAuth" forBody:@"command"];

        //=========== 요청자구분 ===========
        [tr putValue:@"app" forBody:@"bizReqType"];

        //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
        [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
        [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif


        //=========== 간편비밀번호 ===========
        [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword1]  forBody:@"pinPwd"];

        //=========== 디바이스/앱 ID ===========
        [tr putValue:onePassManager.deviceId forBody:@"deviceId"];
        [tr putValue:onePassManager.facetId forBody:@"appId"];

        
        //=========== 통합 ID ===========
//        [tr putValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGING_ICID"] forBody:@"icId"];
//        NSLog(@"통합 ID =  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGING_ICID"]);
        [tr putValue:[[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
        NSLog(@"통합 ID =  %@",[[SHICUser defaultUser] get:KEY_ICID]);
        
        //=========== 인증장치 타입 ===========
        // 지문 2, Pin 512
        [tr putValue:_verifyType forBody:@"verifyType"];

        //=========== 해지/폐기여부 ===========
        _requestType = [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"]];
        [tr putValue:_requestType forBody:@"requestType"];
//        if( commandType == FidoCommandForUserPause){
//            [tr putValue:@"301" forBody:@"requestType"]; // 3 정지 | 4 혜지
//        }
//        else if(commandType == FidoCommandForUserRelease){
//            [tr putValue:@"300" forBody:@"requestType"];
//        }
        
    }
    /**********************************************************************
     * Parameter Set *
     * 허용단말 리스트
     **********************************************************************/
    else if(commandType ==FidoCommandForAllowedDevice){
        tr.code = @"allowedAuthnr";
        //=========== 요청구분 ===========
        [tr putValue:@"allowedAuthnr" forBody:@"command"];
        
        //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
        [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
        [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif
        //=========== 인증장치 타입 ===========
        // 지문 2, Pin 512
        [tr putValue:SERVERCODE_VERIFYTYPE_PIN forBody:@"verifyType"];
        
    }
    /**********************************************************************
     * Parameter Set *
     * 전자서명 (500)
     **********************************************************************/
    else if(commandType == FidoCommandForElectronicSign){
        tr.code =@"requestIssueCert";

        //=========== 요청구분 ===========
        [tr putValue:@"requestServiceAuth2" forBody:@"command"];

        //=========== 요청자구분 ===========
        [tr putValue:@"app" forBody:@"bizReqType"];

        //=========== 사이트/서비스 ID ===========
#ifdef TEST_GROUP1
        [tr putValue:SHIC_ONEPASS_SITEID forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID forBody:@"svcId"];
#else
        [tr putValue:SHIC_ONEPASS_SITEID_2 forBody:@"siteId"];
        [tr putValue:SHIC_ONEPASS_SVCID_2 forBody:@"svcId"];
#endif

        //=========== 디바이스/앱 ID ===========
        [tr putValue:onePassManager.deviceId forBody:@"deviceId"];
        [tr putValue:onePassManager.facetId forBody:@"appId"];


        //=========== 인증장치 타입 ===========
        [tr putValue:_verifyType forBody:@"verifyType"];

        //*** 인증장치 PIN(512) 시
        if([_verifyType isEqualToString:SERVERCODE_VERIFYTYPE_PIN]){
            //=========== 간편비밀번호 ===========
            [tr putValue:[(AppDelegate *)[[UIApplication sharedApplication] delegate] checkPassword1]  forBody:@"pinPwd"];
        }

        //=========== 고객 번호(CI) =============
        NSMutableDictionary *userInfo= [UserInfo getUserInfo];
        [tr putValue:[userInfo objectForKey:KEY_ICID] forBody:@"icId"];

        //=========== 거래내역 =============
        NSString *hexHash = [CryptoUtil hexString:[CryptoUtil getHash:[D_CA.getUserInfo.ElectronicSignData dataUsingEncoding:NSUTF8StringEncoding] hashAlg:Hash_SHA256]];
        [tr putValue:hexHash forBody:@"svcTrChallenge"];
        
        //=========== 거래타입 =============
        [tr putValue:@"3" forBody:@"transType"];

        //=========== 업무 구분 ===========
        _requestType = [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"]];
        [tr putValue:_requestType forBody:@"requestType"]; //인증

    }


    [tr transmitWithFinished:^(SHICTransaction *tr) {

        NSMutableDictionary * resultDict = tr.response;
        NSString* userid = [[SHICUser defaultUser] get:KEY_CI];
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
        self.rtnicData = resultDict[@"dataBody"][@"icData"];

        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            //Fido 허용단말 리스트
            if([tr.code isEqualToString:@"allowedAuthnr"]){
                [D_CA hideLoading];
                self.isOK=YES;
                self.rtnResultCode=resultCode;
                self.rtnMsg = resultDict[@"dataBody"][@"resultMsg"];
                self.rtnResultData = resultDict[@"dataBody"][@"resultData"];
                [self.delegate fidoResult:self];
                return ;
            }

            trID =resultDict[@"dataBody"][@"resultData"][@"trId"];
            if([tr.code isEqualToString:@"requestServiceRegist"]){
                icID =resultDict[@"dataBody"][@"resultData"][@"icId"];
                [[SHICUser defaultUser] put:KEY_ICID value:icID];
            }

            //=========================== 화면에 인증서 정보를 업데이트가 필요 시 해당 함수 콜백.
            if([self.delegate respondsToSelector:@selector(updateicData:)]){
                [self.delegate updateicData:self];
            }


            [onePassManager setTouchIdString:@"로그인을 위해\n손가락을 홈버튼 위에 터치해 주세요."];
            [onePassManager setIsHidingLoadingView:YES];
#ifdef TEST_GROUP1
            [onePassManager setInitInfo:SHIC_ONEPASS_DOMAIN_SERVER siteId:SHIC_ONEPASS_SITEID serviceId:SHIC_ONEPASS_SVCID userId:userid delegate:self];
#else
            [onePassManager setInitInfo:SHIC_ONEPASS_DOMAIN_SERVER_2 siteId:SHIC_ONEPASS_SITEID_2 serviceId:SHIC_ONEPASS_SVCID_2 userId:userid delegate:self];
#endif
            [onePassManager setTouchidChangeForbid];
            [onePassManager requestWithTrId:trID];

        }//Error 처리
        else{
            [D_CA hideLoading];
            if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
                self.isOK=NO;
                self.rtnOnepassCode = [resultDict[@"dataBody"][@"resultCode"] integerValue];
                self.rtnResultCode=resultCode;
                self.rtnMsg = [self errorMesssagePhaser:resultDict];
                self.rtnResultData = resultDict[@"dataBody"][@"resultData"];
                self.rtnicData = resultDict[@"dataBody"][@"icData"];
                [self.delegate fidoResult:self];
            }

        }
    // 일반적인 에러인경우
    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSMutableDictionary * resultDict = tr.response;
        //NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];
        NSString* errMsg = [self errorMesssagePhaser:resultDict];
        if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
            self.isOK=NO;
            self.rtnMsg = errMsg;
            [self.delegate fidoResult:self];
        }
        
    } cancel:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"cancel");
        if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
            self.isOK=NO;
            self.rtnMsg = @"지문등록에 실패하였습니다.";
            [self.delegate fidoResult:self];
        }
    }];
}
//================================ 완료요청(준비 후 요청완료)
-(void)requestFidoConfirm:(FidoCommandType)confirmType
{
    //OnePassManager* onePassManager = [OnePassManager sharedSingleton];

    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/requestFido"];

    //=========== 요청구분 ===========
    [tr putValue:@"trResultConfirm" forBody:@"command"];
    tr.code =@"trResultConfirm";

    //Return Instance Value ( 요청 했던 command Type을 반환)
    self.cmdType=confirmType;
    
    //=========== 업무 구분 ===========
    _requestType = [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"]];
    [tr putValue:_requestType forBody:@"requestType"]; //인증

    //=========== 고객 번호(CI) =============
    [tr putValue:[[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
    NSLog(@"통합 ID =  %@",[[SHICUser defaultUser] get:KEY_ICID]);


    //=========== 전자서명 (500) (거래 원문)  =============
    if(confirmType == FidoCommandForElectronicSign){
        //===== 오차데이터 테스트.
//        [tr putValue:[NSString stringWithFormat:@"%@Test",D_CA.getUserInfo.ElectronicSignData]  forBody:@"srcDoc"];
        [tr putValue:D_CA.getUserInfo.ElectronicSignData forBody:@"srcDoc"];
    }

    [tr transmitWithFinished:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSMutableDictionary * resultDict = tr.response;
        NSString* trStatus = nil;
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];

        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            trStatus =resultDict[@"dataBody"][@"resultData"][@"trStatus"];
            
            if([tr.code isEqualToString:@"trResultConfirm"] || [tr.code isEqualToString:@"requestServiceAuth"]){
                if ([trStatus isEqualToString:@"1"]){
                    self.isOK=YES;
                    self.rtnicData = resultDict[@"dataBody"][@"icData"];
//                    self.rtnMsg=resultDict[@"dataBody"][@"resultData"][@"trStatus"];
                    self.rtnMsg=resultDict[@"dataBody"][@"resultMsg"];
                    
                    self.rtnResultData=resultDict[@"dataBody"][@"resultData"] ;
                }
                else{
                    NSLog(@"성공이긴 한데...뭔가 다른게 있네...");
                    self.isOK=NO;
                    self.rtnicData = resultDict[@"dataBody"][@"icData"];
                    self.rtnMsg=[NSString stringWithFormat:@"%@[%@]",resultDict[@"dataBody"][@"resultData"][@"trStatusMsg"],resultDict[@"dataBody"][@"resultData"][@"trStatus"]];
                    self.rtnResultData=resultDict[@"dataBody"][@"resultData"];
                    
                }
            }
        }//Error 처리
        else{
            [D_CA hideLoading];
            self.isOK=NO;
            self.rtnicData = resultDict[@"dataBody"][@"icData"];
            self.rtnMsg=resultDict[@"dataBody"][@"resultMsg"];//resultDict[@"dataBody"][@"resultData"][@"trStatus"];
            self.rtnResultData=resultDict[@"dataBody"][@"resultData"];
        }

        if( [self.delegate respondsToSelector:@selector(fidoConfirmResult:)] ){
            [self.delegate fidoConfirmResult:self];
        }
        
    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSMutableDictionary * resultDict = tr.response;
        //NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];
        NSString* errMsg = [self errorMesssagePhaser:resultDict];

        self.isOK=NO;
        self.rtnMsg=errMsg;

        if( [self.delegate respondsToSelector:@selector(fidoConfirmResult:)] ){
            [self.delegate fidoConfirmResult:self];
        }

    } cancel:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"cancel");
        self.isOK=NO;
        self.rtnMsg=@"지문등록에 실패하였습니다.";
        if( [self.delegate respondsToSelector:@selector(fidoConfirmResult:)] ){
            [self.delegate fidoConfirmResult:self];
        }
    }];
}

//================== SSO인증 데이터 요청
-(void)requestSSOData
{
    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    [tr putUri:@"/shic/getSsoData"];


    //=========== 고객 번호(CI) =============
    [tr putValue:[[SHICUser defaultUser] get:KEY_ICID] forBody:@"icId"];
    //=========== 업무 구분 ===========
    [tr putValue:@"203" forBody:@"requestType"];

    [tr transmitWithFinished:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSMutableDictionary * resultDict = tr.response;
        NSString* trStatus = nil;
        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
        trStatus =resultDict[@"dataBody"][@"resultData"][@"trStatus"];

        //성공
        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
            self.isOK=YES;
            self.rtnicData = resultDict[@"dataBody"][@"icData"];
            self.rtnMsg=resultDict[@"dataBody"][@"resultMsg"];
            self.rtnResultData=resultDict;

            if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
                [self.delegate fidoResult:self];
            }
        }//Error 처리
        else{
            self.isOK=NO;
            self.rtnMsg=resultDict[@"dataBody"][@"resultMsg"];

            if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
                [self.delegate fidoResult:self];
            }
        }
    } failed:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"%@",  tr.error);
        NSMutableDictionary * resultDict = tr.response;
        //NSString* errMsg = [NSString stringWithFormat:@"%@",tr.error];
        NSString* errMsg = [self errorMesssagePhaser:resultDict];

        self.isOK=NO;
        self.rtnMsg=errMsg;

        if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
            [self.delegate fidoResult:self];
        }
    } cancel:^(SHICTransaction *tr) {
        [D_CA hideLoading];
        NSLog(@"cancel");
        self.isOK=NO;
        self.rtnMsg=@"";
        if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
            [self.delegate fidoResult:self];
        }
    }];
}

//================== [Onepass] 에러 처리가 필요할 경우 반드시 필요.
//                   (원패스 모듈에서 코드를 분류해 메세지 처리)
-(void)receiveOnePassMessage:(NSDictionary *)msgDict
{
    //[self endProgress];
    //_fidoLoginButton.enabled = YES;

    [D_CA hideLoading];
    
    NSString *lastMsg = nil;
    BOOL isOK = NO;
    int resultCode = [[msgDict objectForKey:ONEPASS_KEY_RESULT_CODE] intValue];
    
    NSString *resultMessage = [msgDict objectForKey:ONEPASS_KEY_RESULT_MESSAGE];
    
    //ONEPASS_OPERATION operation = [[msgDict objectForKey:ONEPASS_KEY_OPERATION] intValue];
    
    if(resultCode == 3) { //지문 취소 버튼 선택시
        if( [self.delegate respondsToSelector:@selector(cancelFido)] )
            [self.delegate cancelFido];
        return;
    }
    //정상
    if(resultCode == 0 || resultCode == 1200){
        lastMsg =[NSString stringWithFormat:@"auth\ncode : %d \n%@",resultCode, resultMessage];
        isOK = YES;
    }
    else if(resultCode == 5 ){
        lastMsg = @"지문이 등록되어 있지 않습니다.\n설정 > Touch ID 및 암호에서 등록";
    }
    else if(resultCode == 100 || resultCode == -16){
        lastMsg = @"휴대폰에 등록된 지문 정보가 변경되었습니다\n 지문인증으로 로그인하기 위해서는 지문을 다시 등록해 주셔야 이용 가능합니다.";
    }
    else if(resultCode == -17){
        lastMsg = @"앱이 재설치 되었을 경우 초기화후 등록을 진행해 주시기 바랍니다.";
    }
    else if( resultCode == 109 || resultCode == 110){
        lastMsg = @"지문이 일치하지 않습니다.\n창을 닫고 지문영역을 터치하여 다시 활성화해 주세요";
    }
    else if (resultCode == -15 || resultCode == -18){
        lastMsg = @"지문인증에 실패하였습니다.\n지문영역을 터치하여 다시 활성화 해주세요.\n설정 > TOUCH ID > iPhone 잠금해제";
    }
    else if(resultCode == 7019){
        lastMsg = @"통신 연결 상태가 좋지 않습니다.\n잠시 후 다시 거래하여 주시기 바랍니다.";
    }
    else if(resultCode == 1){//(디바이스에 지문이 전혀 등록되지 않은 상태 or 암호 끄기 상태)
        lastMsg = @"등록된 지문이 없습니다. (메세지 가이드 필요)";//앱에 지문정모가 없거나 비활성화 인 경우.
    }
    else{
        lastMsg = @"앱이 재설치 되었을 경우 초기화후 등록을 진행해 주시기 바랍니다.[ETC]";
    }

    if( [self.delegate respondsToSelector:@selector(fidoResult:)] ){
        // icdata를 실패 처리시 확인 하도록 되있음. 임시적으로 nil 데이터가 아닌 데이터를 리턴하기 위해 삽입.
        self.rtnicData=[NSDictionary dictionaryWithObjectsAndKeys:
                        @"0",@"cntAuthFail",
                        @"0",@"lock",
                        nil];
        self.isOK = isOK;
        self.rtnMsg = lastMsg;
        self.rtnOnepassCode = resultCode;
        [self.delegate fidoResult:self];
    }
}

//=================== 서버에서 리스폰스된 코드에 따른 메세지 처리
//                    기본포멧 : code , Message
-(NSString*)errorMesssagePhaser:(NSDictionary*)resultDict
{
    NSString *strMessage;
    NSString *strCode;

    if(resultDict[@"dataBody"][@"resultCode"]){
        strCode=resultDict[@"dataBody"][@"resultCode"];
    }
    else if(resultDict[@"dataHeader"][@"resultCode"]){
        strCode=resultDict[@"dataHeader"][@"resultCode"];
    }
    else{
        strCode=@"Etc Code";
    }

    if(resultDict[@"dataBody"][@"resultMsg"]){
        strMessage=resultDict[@"dataBody"][@"resultMsg"];
    }
    else if(resultDict[@"dataHeader"][@"resultMessage"]){
        strMessage=resultDict[@"dataHeader"][@"resultMessage"];
    }
    else{
        strMessage=@"Etc Message";
    }


    return [NSString stringWithFormat:@"code = %@:\n %@",strCode,strMessage];

}
@end

