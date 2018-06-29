//
//  NSObject+CertificateManager.m
//  GroupAppOne
//
//  Created by INBEOM on 2018. 4. 20..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "CertificateManager.h"
#import "AddAuthorizationViewController.h"
#import "AuthorizationViewController.h"
#import "PasswordViewController.h"
#import "CertificateManager.h"

UIViewController *_rootController;
UINavigationController *_rootNavigationController ;

#define MESSAGE_LOGINLOCK @"신한 올패스 비밀번호 입력제한\n 횟수 초과로 인해 서비스가 잠금 상태가 되었습니다. 통합인증비밀번호 제설정 화면으로 이동하시겠습니까?"

@implementation CertificateManager

- (id)initWithDelegate:(id)delegate
{
    self = [super init];

    if(self){
        self.delegate=delegate;
        _rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;;
        if([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
            _rootNavigationController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    }

    return self;
}



// 인증서 상태 체크 Tranjection
#pragma Verify Method

//-(void)requestVerify:(FidoVerifyType)verifyType
//{
//    NSString *icid=nil;
//    NSMutableDictionary *userInfo= [UserInfo getUserInfo];
//    icid = [userInfo objectForKey:KEY_ICID];
//
//    //통합인증 서비스 가입상태 조회
//    FidoTransaction* transaction = [[FidoTransaction alloc] init];
//    transaction.verifyType=self.verifyType;
//    transaction.delegate = self.delegate;
//    [transaction verifyCertification:icid type:verifyType];
//}
//
//
//- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)dataBody
////- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData
//{
//
//    NSLog(@"#ltest +++++++++++++++++++++++++++=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//    // =============== 결과 저장
//    self.resultCode=isOK;
//    if(isOK){
//        if(
//        _commendType == CertificateManageCommandTypeRegist ||               // 가입
//        _commendType == CertificateManageCommandTypeSearchPassword ||       // 비밀번호 찾기
//        _commendType == CertificateManageCommandTypeSearchPassword2         // 비밀번호 찾기 Step2
//           ){
////            [self checkicDataRegist:dataBody[@"icData"]];
//        }
//        else{
//            //================== 인증서 상태 체크 후 결과 콜백.
//            if([CertificateManager checkicDataAuth:dataBody[@"icData"]]){
//
//            }
//            else{
//
//
//            }
//        }
//
//    }
//    else{
//        RUN_ALERT_PANEL(msg);
//    }
//
//
//    if([self.delegate respondsToSelector:@selector(CertificateResult:)]){
//        [self.delegate CertificateResult:self];
//    }
//}
//
//// updateicData 전달.
//- (void)updateicData:(FidoTransaction*)fidoTransaction
//{
//
//    if([self.delegate respondsToSelector:@selector(updateicData:)]){
//        [self.delegate updateicData:fidoTransaction];
//    }
//
//}

/*  인증서 상태 체크(가입 시)
 *
 */
+(void)checkicDataRegist:(NSDictionary*)icData setCommand:(CertificateManageCommandType)commandType
{
    if(!_rootController){
        _rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;;
        if([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
            _rootNavigationController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    }

    //******************** 비밀번호 찾기 시 추가 인증으로 이동
    if(commandType == CertificateManageCommandTypeSearchPassword){
        //취득한 icId를 셋팅
        NSString* icid = icData[@"icId"];
        [[SHICUser defaultUser] put:KEY_ICID value:icid];

        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForPasswordChange forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AddAuthorizationViewController * addAuthViewController = [[AddAuthorizationViewController alloc] init];
        addAuthViewController.viewType=AUTHORIZATIONVIEWTYPEADD_PASSWORDSEARCH;
        [_rootNavigationController pushViewController:addAuthViewController animated:YES];
        return;
    }
    //================== Step2 완료(추가본인 인증 등) Reset화면으로 이동.
    else if(commandType == CertificateManageCommandTypeSearchPassword2){
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForPasswordChange forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        PasswordViewController* passViewController = [[PasswordViewController alloc] init];
        passViewController.viewType = PASSWORDVIEWTYPE_RESET;
        passViewController.isDoReset=YES;
        [_rootNavigationController pushViewController:passViewController animated:YES];
        return;
    }

    //================ 서비스 잠금 처리 시 얼럿 후 진행 불가
    BOOL isLock = [icData[@"lock"] integerValue];
    if(isLock){
        RUN_ALERT_PANEL(@"신한 올패스 비밀번호 입력제한\n 횟수 초과로 인해 서비스가 잠금 상태가 되었습니다.");
        return;
    }


    NSString* stateCode = icData[@"stateCode"];
    if([stateCode length]== 0 ){
        //가입된 정보가 없음.
        //각 그룹사의 추가 본인인증 화면으로 이동 하여 신규가입 처리를 진행한다.
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserJoin forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AddAuthorizationViewController * addAuthViewController = [[AddAuthorizationViewController alloc] init];
        [_rootNavigationController pushViewController:addAuthViewController animated:YES];
    }
    else if( [stateCode isEqualToString:SERVERCODE_STATECODE_SUC]){
        //서비스 가입이 정상
        //각 그룹사의 인증서 정보를 가지고 와서 현재의 인증서 정보를 체크한다.
        NSDictionary * affiliatesCodes = icData[@"affiliatesCodes"];
        NSString* gStateCode = [affiliatesCodes objectForKey:GROUP_CODE];
        NSString* icid = icData[@"icId"];
        // NSString *user = [[SHICUser defaultUser] get:KEY_NAME];

        if(gStateCode == nil){
            //현재 그룹사의 인증서 상태가 없고 다른 그룹사에 있다고 하면,
            //(예를 들어 은행에서 통합인증 서비스 가입을 하고 카드사에서 서비스 가입하려는 경우
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRegist forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //취득한 icId를 셋팅
            [[SHICUser defaultUser] put:KEY_ICID value:icid];
            //핀인증 화면으로 이동
            PasswordViewController* passViewController = [[PasswordViewController alloc] init];
            passViewController.viewType = PASSWORDVIEWTYPE_CONFIRM;
            [_rootNavigationController pushViewController:passViewController animated:YES];
        }
        else if([gStateCode isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
            //현재 그룹사의 인증서 상태가 정지인경우 재등록 절차를 진행
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRe_Regist forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //취득한 icId를 셋팅
            [[SHICUser defaultUser] put:KEY_ICID value:icid];
            //핀인증 화면으로 이동
            PasswordViewController* passViewController = [[PasswordViewController alloc] init];
            passViewController.viewType = PASSWORDVIEWTYPE_CONFIRM;
            [_rootNavigationController pushViewController:passViewController animated:YES];
        }
        else if([gStateCode isEqualToString:SERVERCODE_AFFILIATESCODES_SUC]){
            //현재 상태가 가입되어 사용하고 있는경우
            //등록된 통합인증ID가 존재하는지 확인
            //이전 해당 icid로 가입된 내역이 있다면 팝업.
            if([[[UserInfo getUserInfo] objectForKey:KEY_ICID]
                isEqualToString:icid]){
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"안내"
                                                                  message:@"고객님은 이미 신한 올패스 서비스에 가입되어 있습니다. \n통합인증서비스 로그인 하시겠습니까?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"확인"
                                                        otherButtonTitles:nil];
                message.tag = 100;
                [message show];
            }
            else{
                //앱이 재설치 되었거나 기기 변경에 의한 앱설치로 인하여 통합인증ID가 삭제 된경우
                //재등록의 팝업을 띄우고 진행여부를 판단한다.
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"안내"
                                                                  message:@"신한 통합인증서비스 재등록이 필요합니다. \n 재등록 하시겠습니까?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"취소"
                                                        otherButtonTitles:@"확인",nil];
                message.tag = 200;
                [message show];
                //취득한 icId를 사전에셋팅
                [[SHICUser defaultUser] put:KEY_ICID value:icid];

            }
        }

    }
    else if([stateCode isEqualToString:SERVERCODE_STATECODE_DISSPOSAL]){
        //서비스 가입후 해지된 상황
        //각 그룹사의 추가 본인인증 화면으로 이동 하여 서비스 재가입프로세스를 태워야함.
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRejoin forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AddAuthorizationViewController * addAuthViewController = [[AddAuthorizationViewController alloc] init];
        [_rootNavigationController pushViewController:addAuthViewController animated:YES];
    }
    else {
        //예외처리
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"안내"
                                                          message:@"네트워크 통신 불안으로 인한 오류가 발생하였습니다.. \n 잠시후 다시 이용해주시기 바랍니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        [message show];
    }
}


#pragma uiAlertView Delegate
+(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag){
        case 100:
            break;
        case 200:
        {
            if(buttonIndex == 1){
                [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRe_Regist forKey:@"REQUEST_TYPE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //핀인증 화면으로 이동
                    PasswordViewController* passViewController = [[PasswordViewController alloc] init];
                    passViewController.viewType = PASSWORDVIEWTYPE_CONFIRM;
                    [_rootNavigationController pushViewController:passViewController animated:YES];
                });


            }
        } break;
    }

}



/*  인증서 상태 체크(인증 시)
 *
 */
+(BOOL)checkicDataAuth:(NSDictionary*)icData
{
    if(!_rootController){
        _rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;;
        if([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
            _rootNavigationController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    
    NSDictionary * affiliatesCodes = icData[@"affiliatesCodes"];
    NSString* gStateCode = [affiliatesCodes objectForKey:GROUP_CODE];

    //====================== 만기일을 체크.
    int eValue = [icData[@"expiryDate"] intValue];
    int cValue = [[CommonZone getCurrDate] intValue];
    //====================== 해지된 상태
    if([gStateCode isEqualToString:SERVERCODE_AFFILIATESCODES_DISPOSSAL]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:@"신한통합 인증 서비스가 해지되었습니다.\n 신한통힙인증서비스를 다시 이용하시려면 \n 신한 올패스 가입을 해주시기 바랍니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        [message show];
//        [_rootNavigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    //======================  2) 만기일이 지난경우
    else if(eValue - cValue < 0 && icData[@"expiryDate"]  ){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:@"신한 올패스 서비스 만기일이 \n자났습니다. 통합인증 서비스를 \n가입해 주시기 바랍니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];

        [message show];
        return NO;
    }
    //====================== 정지된 상태
    else if([gStateCode isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:@"신한통합 인증 서비스가 일시 중지 되었습니다.\n 신한통힙인증서비스를 다시 이용하시려면 \n 신한 올패스 등록을 해주시기 바랍니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];

        [message show];
//        [_rootNavigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    //====================== 1) 만기일이 1개월 전일경우
    else if( (eValue - cValue > 0 && eValue - cValue <= 30) && icData[@"expiryDate"] ){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:@"신한 올패스 서비스 만기일이 N일\n남았습니다. 통합인증 서비스 이용\n기간을 연장하시겠습니까?"
                                                         delegate:nil
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인",nil];

        [message show];
        return NO;
    }

    //================ 서비스 잠금 처리 시 얼럿 후 진행 불가
    BOOL isLock = [icData[@"lock"] integerValue];
    if(isLock){
        [self doResetPassword:@"신한 올패스 비밀번호 입력제한\n 횟수 초과로 인해 서비스가 잠금 상태가 되었습니다. 통합인증비밀번호 제설정 화면으로 이동하시겠습니까?"];
        return NO;
    }

    return YES;
}

+(void)checkRequestFido:(FidoTransaction*)fidoTransaction
{
    if(!_rootController){
        _rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;;
        if([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
            _rootNavigationController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    }

    NSInteger failCount = [fidoTransaction.rtnicData[@"cntAuthFail"] integerValue];
    BOOL isLock = [fidoTransaction.rtnicData[@"lock"] integerValue];


    //======================== Onepass 오류 : Fido 상태 변경됨.
    if(fidoTransaction.rtnOnepassCode == 100 || fidoTransaction.rtnOnepassCode == -16){

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:fidoTransaction.rtnMsg
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];

        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"확인"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistAuth forKey:@"REQUEST_TYPE"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 PasswordViewController* passwordView = [[PasswordViewController alloc] init];
                                 passwordView.viewType=PASSWORDVIEWTYPE_CHANGEADDFINGER;
                                 [_rootNavigationController pushViewController:passwordView animated:YES];
                             }];

        [alert addAction:cancel];
        [alert addAction:ok];
        [_rootController presentViewController:alert animated:YES completion:nil];


    }
    //======================== 지문사용 제한 상태
    if(fidoTransaction.rtnOnepassCode == -15 || fidoTransaction.rtnOnepassCode == -18){
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
    //======================== 비밀번호 입력 오류
    else if([fidoTransaction.rtnResultCode isEqualToString:@"AP001"]){
        //Fail Count [5] 초과시 | lock = true  비밀번호 재 설정.
        NSString *strFailMsg = [NSString stringWithFormat
                                :@"신한 올패스 비밀번호가 일치하지 \n 않습니다. (오류횟수 : %ld 회)\n  ※ 누적 5회 오류 시 서비스가 잠금 처리됩니다."
                                ,failCount
                                ];
        RUN_ALERT_PANEL(strFailMsg);
    }

    //======================== 인증서 상태 체크
    if(![CertificateManager checkicDataAuth:fidoTransaction.rtnicData] && fidoTransaction.rtnicData){
        return;
    }
    //======================== 서비스 잠금
    else if(isLock){
        [self doResetPassword:MESSAGE_LOGINLOCK];
    }
    else{
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
}

+(void)doResetPassword:(NSString*)msg
{
    if(!_rootController){
        _rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;;
        if([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
            _rootNavigationController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    }

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"알림"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"취소"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"확인"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             AuthorizationViewController* authViewController = [[AuthorizationViewController alloc] init];
                             authViewController.viewType=AUTHORIZATIONVIEWTYPE_PASSWORDSEARCH;
                             [_rootNavigationController pushViewController:authViewController animated:YES];
                         }];

    [alert addAction:cancel];
    [alert addAction:ok];
    [_rootController presentViewController:alert animated:YES completion:nil];
}


@end
