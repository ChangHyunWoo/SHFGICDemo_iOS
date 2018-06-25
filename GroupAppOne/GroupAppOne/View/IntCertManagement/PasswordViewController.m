//
//  PasswordViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "PWResetCompleteViewController.h"
#import "PasswordViewController.h"
#import "FingerPrintViewController.h"
#import "JoinCompleteViewController.h"
#import "SecuKeyPad.h"

#import "AppDelegate.h"
#import "FidoTransaction.h"

#import <IntergratedCertification/IntergratedCertification.h>

#define D_Title_Confirm @"신한 올패스 비밀번호 확인"
#define D_Title_Normal @"신한 올패스 비밀번호 입력"
#define D_Title_ReInput @"신한 올패스 비밀번호 재 입력"

#define D_alertLbl_Normal @"비밀번호 6자리 숫자를 입력해 주세요."
#define D_alertLbl_InputConfirm @"비밀번호 6자리 숫자를 다시 입력해 주세요."


@interface PasswordViewController ()<SecuKeypadDelegate,FidoTransactionDelegate>
{
    NSString *strInputPassword;//입력 숫자 저장 변수
    NSString *strPassword;// 검증된 암호화 입력 변수 #1
    NSString *strPassword_Confirm; // 검증된 암호화 입력 변수 #2

    //SecurePad 에서 입력한 문자열 비교용 변수
    NSString *strPassword_NonCipher; //#1
    NSString *strPassword_NonCipher_Confirm;//#2

    NSString *numberChiperString;       // transkey 암호화 값 설정
    SecuKeyPad *keyPad;
}

@property(retain, nonatomic) IBOutlet UILabel* inputInfoLbl;
@property(retain, nonatomic) IBOutlet UILabel* commentLbl;
@property(retain, nonatomic) IBOutlet UILabel* alertLbl;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"비밀번호 입력";

    //============ 네비게이션 메뉴 진입 타입별로 버튼노출 분기.
    if([self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET] || [self.viewType isEqualToString:PASSWORDVIEWTYPE_DISPOSALL]
       || [self.viewType isEqualToString:PASSWORDVIEWTYPE_ADDFINGER]
       ){
        [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];
        //**************** 변경(핀|인증서) 여부 분기 처리.
        keyPad = [[SecuKeyPad alloc] initView:self.viewKeyOutput];
        keyPad.secuKeypadDelegate = self;
    }
    else{
        //********* 등록
        [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];
        keyPad = [[SecuKeyPad alloc] initView:self.viewKeyOutput];
        keyPad.secuKeypadDelegate = self;
    }

    //초기 Step1로 시작.
    [self stepByChangeState:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //각 View Type별 State Set.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [keyPad hideKeypad]; //View 제거 시 keypad Hide.
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//======== Clear
-(void)resetView
{
    strPassword=@"";
    strPassword_Confirm=@"";
    //_alertLbl.text=D_alertLbl_Normal;
    [keyPad clear];

    [keyPad showKekypad];
}

#pragma mark - SecuKeyPadDelegate
-(void)secuKeypadReturn:(NSString*)strInputKey
{
//    NSLog(@"secuKeypadReturn : %@",strInputKey);


    //======================= 두번쨰 입력 시 #2 ================= strPassword(검증된입력값) 이 존재 (패스워드 생성시)
    if(strPassword.length > 0 ){
        strPassword_Confirm=strInputKey;
        strPassword_NonCipher_Confirm=keyPad.strNonCipherData;

        //패스워드 일치 하지않음. 초기상태로 복귀.
        if(! [strPassword_NonCipher isEqualToString:strPassword_NonCipher_Confirm]){
            [self resetView];
            RUN_ALERT_PANEL(@"입력한 비밀번호가 일치하지 않습니다.");
        }
        else{
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;

            D_CD.checkPassword1=strPassword;
            D_CD.checkPassword2=strPassword_Confirm;

            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
            NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];

            if([self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET]){ //비밀번호 변경
                [transaction requestFido:FidoCommandForUserAuth];
            }
            else{   //그 외 등록,재등록 등
                [transaction requestFido:(FidoCommandType)requestType];
            }
        }
    }
    //================================= 기타 패스워드 입력(확인 시) | 첫번쨰 입력 #1
    else{
        //******* PinRegist(핀번호 검증(타그룹사에서 생성한 핀번호) / 그룹사 추가 , 재등록 등)
        if([self.viewType isEqualToString:PASSWORDVIEWTYPE_CONFIRM]) {
            [self resetView];
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;
            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
            D_CD.checkPassword1=strInputKey;
//            transaction.requestType= [NSString stringWithFormat:@"%d",FidoCommandForUserRegist];
            [transaction requestFido:FidoCommandForUserRegist];
        }
        //******* PinAuth 등록 전(핀번호 검증)
        else if( [self.viewType isEqualToString:PASSWORDVIEWTYPE_ADDFINGER] || [self.viewType isEqualToString:PASSWORDVIEWTYPE_CHANGEADDFINGER]                ){//지문추가,변경등록
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            delegate.checkPassword1=strInputKey;
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;
            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
            [transaction requestFido:FidoCommandForUserFingerRegistAuth];
        }
        //******** 비밀번호 재설정 인증 시
        else if( [self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET]&&!self.isDoReset){
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            delegate.checkPassword1=strInputKey;
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;
            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
            [transaction requestFido:FidoCommandForUserAuth];
        }
        //******** QR 인증 시
        else if([self.viewType isEqualToString:PASSWORDVIEWTYPE_QRAUTH]){
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserQRAuth forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            D_CD.checkPassword1=strInputKey;
            FidoTransaction* transaction = [[FidoTransaction alloc] init];
            transaction.delegate = self;
            transaction.verifyType = SERVERCODE_VERIFYTYPE_PIN;
            [transaction requestFido:FidoCommandForUserQRAuth];
        }
        //======================*********** #1 첫번쨰 입력
        else{
            [self checkPinRule:strInputKey];
        }
    }

}

// Pin유효성 체크 TR 요청
-(void)checkPinRule:(NSString*)strPin
{
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    strInputPassword=strPin;
    [transaction requestPinCheck:strPin];
}

//각 ViewType별 화면 상태 메세지 출력
-(void)stepByChangeState:(NSInteger)step
{

    // **** 비밀번호 재설정 인 경우
    if([self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET]){
        if(step == 1 && !self.isDoReset){ // 첫번쨰 입력 전 (인증) &&
            //비밀번호 체크
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForPasswordChangeAuth forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.title = D_Title_Confirm;
            _alertLbl.hidden = YES;
            [self resetView];//Step1에선 모든 입력값 초기화.
        }
        // 두번째 입력 (새비밀번호) || self.isDoReset 외부에서 설정 시 Step2로 바로진입.
        else if( (step == 2 || self.isDoReset ) && step != 3){
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForPasswordChange forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.title = D_Title_Normal;
            self.isDoReset=YES; // 비밀번호 재설정
            _alertLbl.hidden = YES;
            _inputInfoLbl.text = D_alertLbl_Normal;
            [keyPad showKekypad];
        }
        // 세번쨰 입력 (새비밀번호 확인)
        else if(step == 3){
            self.title=D_Title_ReInput;
            _alertLbl.hidden = YES;
            _inputInfoLbl.text = D_alertLbl_InputConfirm;
        }
        else{
            [self resetView];
        }
    }
    // **** 패스워드 확인 시 (타 그룹사에서 가입 하여 패스워드 확인하는 경우)
    else if([self.viewType isEqualToString:PASSWORDVIEWTYPE_CONFIRM]){
        if(step == 1){ // 첫번쨰 입력 전
            self.title=D_Title_Confirm;
            _alertLbl.hidden = NO;
            _inputInfoLbl.text = D_alertLbl_Normal;
            [self resetView];//Step1에선 모든 입력값 초기화.
        }
        else{
            [self resetView];
        }
    }
    // **** 기타 가입,등록 재등록 등
    else {
        if(step == 1){ // 첫번쨰 입력 전
            self.title=D_Title_Normal;
            _alertLbl.hidden = YES;
            [self resetView];//Step1에선 모든 입력값 초기화.
        }
        else if(step == 2){ // 두번째 입력
            self.title=D_Title_ReInput;
            _alertLbl.hidden = YES;
            _inputInfoLbl.text = D_alertLbl_InputConfirm;
        }
        else{
            [self resetView];
        }
    }

}


#pragma mark - FidoTransaction Delegate
//핀 유효성검사 Result (#1)
- (void)pinCheckResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData
{
    if(isOK){
        //************* 검증된 입력값 저장 #1
        //첫번쨰 입력 저장.
        strPassword=strInputPassword;
        strPassword_NonCipher=keyPad.strNonCipherData;
        [keyPad clear];
        [keyPad showKekypad];
        //_alertLbl.text=D_alertLbl_InputConfirm;

        //2단계 Step
        if([self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET]) // Result의 경우 1step 은 패스 워드 확인 (Auth)임으로 3Step
            [self stepByChangeState:3];
        else
            [self stepByChangeState:2];
    }
    else{
        [self resetView];
        RUN_ALERT_PANEL(msg);
    }
}

- (void)fidoResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){

        //******** QR 인증 시
        if([self.viewType isEqualToString:PASSWORDVIEWTYPE_QRAUTH]){
            RUN_ALERT_PANEL(@"QR인증에 성공하였습니다.\n 인증확인을 해주세요.");
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
        // ***** 비밀번호 입력 오류
        BOOL isLock = [fidoTransaction.rtnicData[@"lock"] integerValue];
        NSInteger failCount = [fidoTransaction.rtnicData[@"cntAuthFail"] integerValue];

        [self resetView];
        
        //Fail Count [5] 초과시 | lock = true  비밀번호 재 설정.
        if(isLock){
            RUN_ALERT_PANEL(@"신한 올패스 비밀번호 입력제한\n 횟수 초과로 인해 서비스가 잠금 상태가 되었습니다.");
        }
        else if([fidoTransaction.rtnResultCode isEqualToString:@"RP002"] || [fidoTransaction.rtnResultCode isEqualToString:@"AP001"]){
            //Fail Count [5] 초과시 | lock = true  비밀번호 재 설정.
            NSString *strFailMsg = [NSString stringWithFormat
                                    :@"신한 올패스 비밀번호가 일치하지 \n 않습니다. (오류횟수 : %ld 회)\n  ※ 누적 5회 오류 시 서비스가 잠금 처리됩니다."
                                    ,failCount
                                    ];
            RUN_ALERT_PANEL(strFailMsg);
        }
        else{
            RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
        }

    }
}

- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        // **** 가입 | 재가입 | 재등록 등
        if(requestType == FidoCommandForUserJoin || requestType == FidoCommandForUserRegist
            || requestType == FidoCommandForUserRejoin || requestType == FidoCommandForUserRe_Regist ){
            //*** FaceID는 완료화면으로 바로 이동.
            BOOL available = [D_CA isTouchValiable];
            if(available){
                FingerPrintViewController* fingerViewConroller = [[FingerPrintViewController alloc] init];
                //추가 지문 등록처리로 분기
                if([self.viewType isEqualToString:PASSWORDVIEWTYPE_ADDFINGER]){
                    fingerViewConroller.viewType=FINGERPRINTVIEW_FingerRegist;
                }
                [self.navigationController pushViewController:fingerViewConroller animated:YES];
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

                //가입 완료 화면으로 이동
                JoinCompleteViewController* joinCompleteViewController = [[JoinCompleteViewController alloc] init];
                [self.navigationController pushViewController:joinCompleteViewController animated:YES];
            }
        }
        // **** 핀체크(인증) | 지문추가,변경 | 비밀번호 재설정 | 지문등록 등
        else if(requestType == FidoCommandForUserAuth || requestType == FidoCommandForPasswordChangeAuth || requestType == FidoCommandForUserFingerRegistAuth){
            if([self.viewType isEqualToString:PASSWORDVIEWTYPE_ADDFINGER]){
                [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistSend forKey:@"REQUEST_TYPE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                FingerPrintViewController* fingerViewConroller = [[FingerPrintViewController alloc] init];
                fingerViewConroller.viewType=FINGERPRINTVIEW_FingerRegist;
                [self.navigationController pushViewController:fingerViewConroller animated:YES] ;
            }
            else if([self.viewType isEqualToString:PASSWORDVIEWTYPE_CHANGEADDFINGER]){
                [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistSend forKey:@"REQUEST_TYPE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                FingerPrintViewController* fingerViewConroller = [[FingerPrintViewController alloc] init];
                fingerViewConroller.viewType=FINGERPRINTVIEW_FingerChange;
                [self.navigationController pushViewController:fingerViewConroller animated:YES] ;
            }
            //비밀번호 재 설정 인증 시
            else if([fidoTransaction.requestType integerValue] == FidoVerifyPasswordChangeAuth && [self.viewType isEqualToString:PASSWORDVIEWTYPE_RESET]){
                [self stepByChangeState:2];// Step2 새로운 비밀번호 입력.
                [self resetView];
            }
        }
        //비밀번호 재 설정 시
        else if(requestType == FidoVerifyPasswordChange){
            //완료화면 이동
            PWResetCompleteViewController *completeView = [[PWResetCompleteViewController alloc] init];
            [self.navigationController pushViewController:completeView animated:YES];
        }
    }
    else{
        [self resetView];
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }

}


@end
