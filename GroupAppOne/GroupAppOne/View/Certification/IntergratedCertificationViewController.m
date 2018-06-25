//
//  IntergratedCertificationViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>

#import "IntergratedCertificationViewController.h"
#import "PasswordViewController.h"
#import "PauseCompleteViewController.h"
#import "DisposalCompleteViewController.h"
#import "AuthorizationViewController.h"

#import "SecuKeyPad.h"
#import "FidoTransaction.h"
#import "AppDelegate.h"

#define MESSAGE_LOGINLOCK @"신한 올패스 비밀번호 입력제한\n 횟수 초과로 인해 서비스가 잠금 상태가 되었습니다. 통합인증비밀번호 제설정 화면으로 이동하시겠습니까?"

@interface IntergratedCertificationViewController () <SecuKeypadDelegate, FidoTransactionDelegate,CertificateDelegate>
{
    NSString *strPassword;
    NSString *numberChiperString;       // transkey 암호화 값 설정
    SecuKeyPad *keyPad;
    IntCertCallType callType;
    
}

@property(nonatomic, strong) IBOutlet UILabel* nameLbl;
@property(nonatomic, strong) IBOutlet UILabel* expireLbl;
@property (weak, nonatomic) IBOutlet UIButton *btnFingerLogin;

@end

@implementation IntergratedCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"로그인";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];

    [D_CA setButtonBorder:_btnFingerLogin setBorderColor:@"#161c34"];


    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(contentViewTouchupInside:)];
    [self.view addGestureRecognizer:singleFingerTap];

    [self performSelector:@selector(initScrollView) withObject:nil afterDelay:0.0];


    //KeypadInit
    keyPad = [[SecuKeyPad alloc] initView:self.viewKeyOutput];
    keyPad.secuKeypadDelegate = self;
    [keyPad initBaseView:self.scrollViewBody];


    [self setUserInfo];
}

-(void)initScrollView
{
    if (self.scrollViewBody != nil)
    {
        if (self.scrollViewBody.frame.size.height > self.viewContents.frame.size.height)
        {
            [self.viewContents setFrame:CGRectMake(self.viewContents.frame.origin.x, self.viewContents.frame.origin.y, self.scrollViewBody.frame.size.width, self.scrollViewBody.frame.size.height)];
        }
        else
        {
            [self.viewContents setFrame:CGRectMake(self.viewContents.frame.origin.x, self.viewContents.frame.origin.y, self.scrollViewBody.frame.size.width, self.viewContents.frame.size.height)];
        }

        //시작할때 스크롤 뷰에 삽입한다.
        [_scrollViewBody addSubview:self.viewContents];

        CGRect rect = self.viewContents.bounds;

        [self.scrollViewBody setContentSize:CGSizeMake(self.scrollViewBody.frame.size.width, rect.size.height)];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (IOS_VERSION_GREATER_THAN(11) && IS_IPHONE_X){
        /***** TopLayout / BottomLayou GuideViewHeight *****/
        [_viewTopLayoutHeightConstraint setConstant:self.topLayoutGuide.length];
        [_viewBottomLayoutHeightConstraint setConstant: self.bottomLayoutGuide.length ];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [keyPad hideKeypad];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==================== 로그인설정 타입별 로그인시도
- (void)runLogging
{
    // 로그인설정 체크
    NSMutableDictionary *dicUserInfo = [UserInfo getUserInfo];

    //============= 1 핀인증 (키패드 입력 후 요청)
    if([[dicUserInfo objectForKey:KEY_LOGIN_TYPE] isEqualToString:@"00"]){
        [keyPad showKekypad];
    }
    //============= 2 지문인증 (지문인증 요청) 
    else{
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;


        transaction.verifyType = SERVERCODE_VERIFYTYPE_FIDO;

        if(callType == CallTypePause){ //정지
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserPause forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [transaction requestFido:FidoCommandForUserPause];
        }
        else if( callType == CallTypeDisposal){ // 해지
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRelease forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [transaction requestFido:FidoCommandForUserRelease];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserAuth forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [transaction requestFido:FidoCommandForUserAuth];
        }
    }
}

- (void)setUserInfo
{
//    NSString *icid=nil;
    NSMutableDictionary *userInfo= [UserInfo getUserInfo];

    //************** 로그인설정 체크

    //기존 등록 정보가 있다면 icID로 전송.
    if(userInfo){
        //Pin 설정일때만 Verify 요청.
        if([[userInfo objectForKey:KEY_LOGIN_TYPE] isEqualToString:@"00"]){
//            FidoTransaction* transaction = [[FidoTransaction alloc] init];
//            transaction.delegate = self;
//            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
//            icid = [userInfo objectForKey:KEY_ICID];
//            [[SHICUser defaultUser] put:KEY_ICID value:icid];
//
//            [[NSUserDefaults standardUserDefaults] setInteger:FidoVerifyAuth forKey:@"REQUEST_TYPE"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            [transaction verifyCertification:icid type:FidoVerifyAuth];

            
//            CertificateManager *certManager = [[CertificateManager alloc] initWithCommandType:CertificateManageCommandTypeAuth];

            CertificateManager *certManager = [[CertificateManager alloc] initWithDelegate:self];
            certManager.commendType=CertificateManageCommandTypeAuth;
            certManager.verifyType=SERVERCODE_VERIFYTYPE_PIN;
            [certManager requestVerify:FidoVerifyAuth];

        }
        //Fido Request.
        else{
            [self runLogging];
        }
    }
    //기존 등록정보가 없다면 ICNO 정보 전송.
    else{
        //에러처리
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}
#pragma mark - SecuKeyPadDelegate
-(void)secuKeypadReturn:(NSString*)strInputKey
{
    NSLog(@"secuKeypadReturn : %@",strInputKey);
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.checkPassword1=strInputKey;
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    
   // [transaction requestFido:FidoCommandForUserAuthPin];

    transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;


    if(callType == CallTypePause){ //정지
        [[NSUserDefaults standardUserDefaults] setInteger:FidoVerifyPause forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [transaction requestFido:FidoCommandForUserPause];
    }
    else if( callType == CallTypeDisposal){ // 해지
        [[NSUserDefaults standardUserDefaults] setInteger:FidoVerifyDisposal forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [transaction requestFido:FidoCommandForUserRelease];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:FidoVerifyAuth forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [transaction requestFido:FidoCommandForUserAuth];
    }

}
#pragma mark - FidoTransactionDelegate

- (void)CertificateResult:(CertificateManager*)certificate
{
    
    if(certificate.resultCode){
        self.nameLbl.text = [[SHICUser defaultUser] get:KEY_NAME];
        NSString* formatStr = [CommonZone DateFormate:certificate.resulticData[@"icData"][@"expiryDate"]];
        self.expireLbl.text = [NSString stringWithFormat:@"만료일 %@",formatStr];
        //각 그룹사의 인증서 정보를 가지고 와서 현재의 인증서 정보를 체크한다.

        //================ 모두 정상.
        if([CertificateManager checkicDataAuth:certificate.resulticData[@"icData"]]){
            [self runLogging];
            return;
        }
    }
    else{
        [keyPad clear];
    }
}


- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)dataBody{

    if(isOK){
        NSString* stateCode = dataBody[@"icData"][@"stateCode"];
        if(stateCode !=nil && [stateCode isEqualToString:SERVERCODE_STATECODE_SUC]){
            //================ 모두 정상.
            if([CertificateManager checkicDataAuth:dataBody[@"icData"]]){
                [self runLogging];
                return;
            }
        }
        else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"로그인"
                                                              message:@"등록된 인증서가 해지 되었거나 삭제되었습니다."
                                                             delegate:nil
                                                    cancelButtonTitle:@"확인"
                                                    otherButtonTitles:nil];
            
            [message show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else {

        //================ 서비스 잠금 처리 시 얼럿 후 진행 불가
        BOOL isLock = [dataBody[@"icData"][@"lock"] integerValue];
        if(isLock){
            [self doResetPassword:MESSAGE_LOGINLOCK];
            return;
        }

        [keyPad clear];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"로그인 실패"
                                                          message:msg
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];

        [message show];
    }
}

//- (void)fidoResult:(BOOL)isOK message:(NSString *)msg data:(NSDictionary *)resultData{
- (void)fidoResult:(FidoTransaction*)fidoTransaction{
    NSLog(@"fidoResult : <><><> %@ <><><>",fidoTransaction.rtnResultData);

    if(fidoTransaction.isOK){
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;

        if(callType == CallTypeDisposal){
            NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
            [transaction requestFidoConfirm:(FidoCommandType)requestType];

        }
        else if(callType == CallTypePause){
            NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
            [transaction requestFidoConfirm:(FidoCommandType)requestType];
        }
        else{
            NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
            [transaction requestFidoConfirm:(FidoCommandType)requestType];
        }

        // **** 로그인시 전자서명 데이터를 유저정보에 저장 .  | 임시데이터 삽입
        D_CA.getUserInfo.ElectronicSignData = @"(1) 거래일자 : 2018.03.30\n(2) 거래시간 : 15:45:14\n(3) 출금계좌번호 : 123-45-678910\n(4) 입금은행 : 신한은행\n(5) 입금계좌번호 : 11090876543210\n(6) 받는분 : 홍길동\n(7) 이체금액 : 200,0000원\n(8) 수수료 : 1,000원\n(9) 받는통장메모 : 점심값\n(10) 내통장메모 : 길동점심값";


    }
    else{
        [keyPad clear];
        [CertificateManager checkRequestFido:fidoTransaction];
    }
}
//- (void)fidoConfirmResult:(BOOL)isOK message:(NSString *)msg data:(NSDictionary *)resultData{
- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction
{
     if(fidoTransaction.isOK){
         //*************** 임시 주석. SDK쪽 반영 후 재설정 Lock 헤제 가능 시에 적용 .
         if(callType ==CallTypePause){
             [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
             PauseCompleteViewController* pauseViewController = [[PauseCompleteViewController alloc] init];
             [self.navigationController pushViewController:pauseViewController animated:YES];
         }
         else if(callType ==CallTypeDisposal){
             [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
             [UserInfo removeUserInfo];
             DisposalCompleteViewController * disposalViewController = [[DisposalCompleteViewController alloc] init];
             [self.navigationController pushViewController:disposalViewController animated:YES];
         }
         else{
             [[SHICUser defaultUser] put:KEY_LOGIN value:@(YES)];
             //메인으로 이동
             RUN_ALERT_PANEL(@"인증에 성공하였습니다.");
             //로그인 결과 정보 저장

             [self.navigationController popToRootViewControllerAnimated:YES];
         }
     }
    else {
        [keyPad clear];
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
}

- (void)updateicData:(FidoTransaction*)fidoTransaction
{
    self.nameLbl.text = [[SHICUser defaultUser] get:KEY_NAME];
    NSString* formatStr = [CommonZone DateFormate:fidoTransaction.rtnicData[@"expiryDate"]];
    self.expireLbl.text = [NSString stringWithFormat:@"만료일 %@",formatStr];
}

#pragma mark - IBAction
- (IBAction)fingerLoginTouchUpInside:(id)sender
{
    [keyPad hideKeypad];
    [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserAuth forKey:@"REQUEST_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserInfo checkFingerRegist:self setDelegate:self];
}

- (void)callTypeSet:(IntCertCallType)type
{
    callType = type;
}

//비밀번호 찾기
- (IBAction)passwordSearchTouchUpInside:(id)sender
{
    AuthorizationViewController* authViewController = [[AuthorizationViewController alloc] init];
    authViewController.viewType=AUTHORIZATIONVIEWTYPE_PASSWORDSEARCH;
    [self.navigationController pushViewController:authViewController animated:YES];
}

- (void)contentViewTouchupInside:(UITapGestureRecognizer *)recognizer
{
    [keyPad hideKeypad];
}

#pragma uiAlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistAuth forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        PasswordViewController* passwordView = [[PasswordViewController alloc] init];
        passwordView.viewType=PASSWORDVIEWTYPE_CHANGEADDFINGER;
        [self.navigationController pushViewController:passwordView animated:YES];
    }
}

-(void)doResetPassword:(NSString*)msg
{
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
                             [self.navigationController pushViewController:authViewController animated:YES];
                         }];

    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
