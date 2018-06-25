//
//  FingerPrintViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>

#import "FingerPrintViewController.h"
#import "SelectLoginOptionViewController.h"
#import "IntCertManagementViewController.h"

#import <public_onepass/OnePassManager.h>
#import <public_onepass/OnePassDefine.h>
#import "JoinCompleteViewController.h"
#import "FidoTransaction.h"
#import "AppDelegate.h"

//#import "OnePassTestUtil.h"
//#import "OnePassTestDefine.h"

@interface FingerPrintViewController ()<FidoTransactionDelegate>
{
    FidoTransaction* transaction;
}
@property(nonatomic, retain) IBOutlet UIButton* skipBtn;
@property(nonatomic, retain) IBOutlet UIButton* registBtn;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* activeIndigator;
@end

@implementation FingerPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"신한 올패스 지문 인증";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:NO isRightMenu:YES];
    
//    OnePassManager* onePassManager = [OnePassManager sharedSingleton];
//    NSString* appId = onePassManager.facetId;
//    NSLog(@"App ID = %@", appId);
    [D_CA setButtonBorder:_skipBtn setBorderColor:@"#161c34"];
    [D_CA setButtonBorder:_registBtn setBorderColor:@""];

    if([_viewType isEqualToString:FINGERPRINTVIEW_FingerRegist] || [_viewType isEqualToString:FINGERPRINTVIEW_FingerChange]
       ){
        [_skipBtn setTitle:@"취소" forState:UIControlStateNormal];
    }
    //=================== QR인증
    else if([_viewType isEqualToString:FINGERPRINTVIEW_FingerQRAuth]){
        [_skipBtn setTitle:@"취소" forState:UIControlStateNormal];
        [_registBtn setTitle:@"확인" forState:UIControlStateNormal];
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        transaction.verifyType = SERVERCODE_VERIFYTYPE_FIDO;
        [transaction requestFido:FidoCommandForUserQRAuth];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipTouchUpInside:(id)sender{

    //지문 추가 등록 시 뒤로가기 분기 처리.
    if([_viewType isEqualToString:FINGERPRINTVIEW_FingerRegist]||[_viewType isEqualToString:FINGERPRINTVIEW_FingerChange]
       || [_viewType isEqualToString:FINGERPRINTVIEW_FingerQRAuth]
       ){
        for (UIViewController *view in [self.navigationController viewControllers]){
            if([view isKindOfClass:[SelectLoginOptionViewController class]]){
                [self.navigationController popToViewController:view animated:YES];
                return;
            }
        }

        //SelectLoginOptionViewController가 상위에 없을 경우 Rootpopup
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        NSString*    icID = [[SHICUser defaultUser] get:KEY_ICID];
        NSString * userName = [[SHICUser defaultUser] get:KEY_NAME];

        //통합ID 저장
        NSDictionary* intCertDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     userName, KEY_NAME,
                                     [D_CA.getUserInfo getUserCI:userName], KEY_CI,
                                     icID,KEY_ICID,
                                     @"00",KEY_LOGIN_TYPE,
                                     nil];
        [UserInfo saveUesrInfo:intCertDict];


        JoinCompleteViewController* joinCompleteViewController = [[JoinCompleteViewController alloc] init];
        [self.navigationController pushViewController:joinCompleteViewController animated:YES];
    }
    
}
- (IBAction)registerTouchUpInside:(id)sender{
    //지문 등록. //지문 변경 등록
    if([_viewType isEqualToString:FINGERPRINTVIEW_FingerRegist]  || [_viewType isEqualToString:FINGERPRINTVIEW_FingerChange]){
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        transaction.verifyType= SERVERCODE_VERIFYTYPE_FIDO;
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistSend forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [transaction requestFido:FidoCommandForUserFingerRegistSend];
    }
    //====================== QR인증
    else if([_viewType isEqualToString:FINGERPRINTVIEW_FingerQRAuth]){
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        transaction.verifyType = SERVERCODE_VERIFYTYPE_FIDO;
        [transaction requestFido:FidoCommandForUserQRAuth];
    }
    else{
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        transaction.verifyType = SERVERCODE_VERIFYTYPE_FIDO;
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        [transaction requestFido:(FidoCommandType)requestType];
    }
   
}

#pragma mark - FidoTransaction Delegate
//- (void)fidoResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData
- (void)fidoResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){

        //====================== QR인증 완료시 Confirm은 Web처리 함으로 종료.
        if([_viewType isEqualToString:FINGERPRINTVIEW_FingerQRAuth]){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"로그인"
                                                              message:@"QR인증에 성공하였습니다.\n 인증확인을 해주세요."
                                                             delegate:nil
                                                    cancelButtonTitle:@"확인"
                                                    otherButtonTitles:nil];

            [message show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;
            NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
            [transaction requestFidoConfirm:(FidoCommandType)requestType];
        }

    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:fidoTransaction.rtnMsg
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

//- (void)fidoConfirmResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData
- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){
        NSString* icID = fidoTransaction.rtnResultData[@"loginId"];
        //임의코드 확인필요!!
        if(icID ==nil){
            icID = [[SHICUser defaultUser] get:KEY_ICID];
        }

        NSString * userName = [[SHICUser defaultUser] get:KEY_NAME];
        NSDictionary* intCertDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     userName, KEY_NAME,
                                     [D_CA.getUserInfo getUserCI:userName], KEY_CI,
                                     icID,KEY_ICID,
                                     @"01",KEY_LOGIN_TYPE,
                                     @"01",KEY_ISREGISTFIDO,
                                     nil];

        [UserInfo saveUesrInfo:intCertDict];

        //지문 추가 등록 시 뒤로가기 분기 처리.
        if([_viewType isEqualToString:FINGERPRINTVIEW_FingerRegist]){
            for (UIViewController *view in [self.navigationController viewControllers]){
                if([view isKindOfClass:[SelectLoginOptionViewController class]]){
                    [self.navigationController popToViewController:view animated:YES];
                    [(SelectLoginOptionViewController*)view setLoginType:@"01"];
                    return;
                }
            }

            //SelectLoginOptionViewController가 상위에 없을 경우 Rootpopup  | 로그인화면에서 등록 한 경우.
            [self.navigationController popToRootViewControllerAnimated:YES];
            //로그인창 이동.
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if([_viewType isEqualToString:FINGERPRINTVIEW_FingerChange]){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            //가입 완료 화면으로 이동
            JoinCompleteViewController* joinCompleteViewController = [[JoinCompleteViewController alloc] init];
            [self.navigationController pushViewController:joinCompleteViewController animated:YES];
        }

        
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"OnePass"
                                                          message:fidoTransaction.rtnMsg
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

- (void)cancelFido
{
    if([_viewType isEqualToString:FINGERPRINTVIEW_FingerQRAuth]){

        for (UIViewController *view in [self.navigationController viewControllers]){
            if([view isKindOfClass:[IntCertManagementViewController class]]){
                [self.navigationController popToViewController:view animated:YES];
                return;
            }
        }
    }
}

@end
