//
//  SSOViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 3. 28..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import "SSOViewController.h"
#import "NSData+Base64.h"

@interface SSOViewController ()<SSOManagerDelegate,FidoTransactionDelegate>
{
    NSString* _otherAppSchemeCode;
    NSDictionary *_affiliatesCodes;
    NSDictionary *_dicTestAppName;
    NSDictionary *_dicTestAppIcon;
    NSDictionary *_dicTestAppsShemes;
    NSDictionary *_dicTestAppHost;
    BOOL isDissposal;
}
@property(nonatomic, strong) IBOutlet UIButton* otherBtn;
@property(nonatomic, strong) IBOutlet UILabel* otherLbl;
@property (weak, nonatomic) IBOutlet UIImageView *otherState;

@property(nonatomic, strong) IBOutlet UIButton* otherBtn2;
@property(nonatomic, strong) IBOutlet UILabel* otherLbl2;
@property (weak, nonatomic) IBOutlet UIImageView *otherState2;

@property(nonatomic, strong) IBOutlet UIButton* otherBtn3;
@property(nonatomic, strong) IBOutlet UILabel* otherLbl3;
@property (weak, nonatomic) IBOutlet UIImageView *otherState3;


@end

@implementation SSOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"그룹사간 SSO 테스트";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];


    _dicTestAppName = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"은행",@"001",
                    @"카드",@"002",
                    @"생명",@"003",
                    @"금투",@"004"
                    , nil];

    _dicTestAppIcon = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"ico_app_sol@3x.png",@"001",
                       @"ico_app_fan@3x.png",@"002",
                       @"ico_app_life@3x.png",@"003",
                       @"ico_app_ia@3x.png",@"004"
                       , nil];

    /* 그룹사 앱 정보.   ****** 현재 데모기준 1,2,3 : 은행/카드/생명
     은행 : iphoneSbank :// null
     카드 : shinhan-appcard :// blcsso
     생명 : shlic (운영) shlicT (테스트) :// smtsso
     금투 : NewShinhanAlpha :// shasso
     */
    _dicTestAppsShemes = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"iphoneSbank",@"001",
                    @"shinhan-appcard",@"002",
                    @"shlicT",@"003",
                    @"NewShinhanAlpha",@"004"
                    , nil];

    _dicTestAppHost = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"TestString",@"001", //************ 은행 Host 구분 없음.
                          @"blcsso",@"002",
                          @"smtsso",@"003",
                          @"shasso",@"004"
                          , nil];


    FidoTransaction *tranjection = [[FidoTransaction alloc] init];
    tranjection.delegate=self;

    NSMutableDictionary *userInfo= [UserInfo getUserInfo];
    NSString* icid = [userInfo objectForKey:KEY_ICID];
    [tranjection inquireCertification:icid];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//================= 앱상태 업데이트.
-(void)initAppList:(NSDictionary*)dicAffiliatesCodes
{
    int idx = 0;
    for(NSString *strCode in [_dicTestAppName allKeys]){


        //===================== 현재앱을 제외
        NSString* bundleID=[[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
        if( [ bundleID isEqualToString: [_dicTestAppsShemes objectForKey:strCode]]){
            continue;
        }

        /*=================== 그룹사 앱 목록 Init.
         * 상태별 아이콘 명
         * ico_sso_login_dis.png
         * ico_sso_login.png
         */
        switch (idx) {
            case 0:
                self.otherLbl.text = [_dicTestAppName objectForKey:strCode];
                [self.otherBtn setTitle:strCode forState:UIControlStateNormal];
                [self.otherBtn setBackgroundImage:[UIImage imageNamed:[_dicTestAppIcon objectForKey:strCode]] forState:UIControlStateNormal];
                [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState];
                break;
            case 1:
                self.otherLbl2.text = [_dicTestAppName objectForKey:strCode];
                [self.otherBtn2 setTitle:strCode forState:UIControlStateNormal];
                [self.otherBtn2 setBackgroundImage:[UIImage imageNamed:[_dicTestAppIcon objectForKey:strCode]] forState:UIControlStateNormal];
                [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState2];
                break;
            case 2:
                self.otherLbl3.text = [_dicTestAppName objectForKey:strCode];
                [self.otherBtn3 setTitle:strCode forState:UIControlStateNormal];
                [self.otherBtn3 setBackgroundImage:[UIImage imageNamed:[_dicTestAppIcon objectForKey:strCode]] forState:UIControlStateNormal];
                [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState3];
                break;
        }
        idx++;
    }
}

-(void)updateIcon:(NSString*)stateCode setButton:(UIImageView*)imageview
{
    /* 서비스 상태별 아이콘
     정지      : ico_sso_login_dis.png
     가입/등록  : ico_sso_login.png
     미가입    : Hidden
     */
    if([stateCode isEqualToString:SERVERCODE_STATECODE_SUC]){
        imageview.hidden=NO;
        [imageview setImage:[UIImage imageNamed:@"ico_sso_login.png"]];
    }
    else if([stateCode isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
        imageview.hidden=NO;
        [imageview setImage:[UIImage imageNamed:@"ico_sso_login_dis.png"]];
    }
    else{
        imageview.hidden=YES;
    }
}
#pragma -buttonEvent
-(IBAction)otherBtnTouchUpInside:(id)sender
{

    BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN];
    /*
     링크하고자 하는 그룹사앱의 가입여부를 판단
     2번 정지일 경우만 정지 메시지 팝업, 미가입/가입상태는 해당 앱에 보낸 후 가입/로그인 절차 진행
     */
    BOOL isServiceOn = YES;

    // Schmes Init
    NSString *senderCode=[sender titleLabel].text;

    // ** 예외처리.
    if(senderCode.length <= 0){
        return;
    }

    _otherAppSchemeCode=senderCode;

    if([[_affiliatesCodes objectForKey:senderCode ] isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
        isServiceOn=NO;
    }

    //통합인증 로그인 및 링크앱의 서비스 가입여부가 YES일 경우만 SSO를 진행한다.
    if(isLogin){
        if(isServiceOn){
            FidoTransaction *tranjection = [[FidoTransaction alloc] init];
            tranjection.delegate=self;
            [tranjection requestSSOData];
        }
        else{

            //======================== 인증서 상태 체크
//            if(![CertificateManager checkicDataAuth:fidoTransaction.rtnicData] && fidoTransaction.rtnicData){
//                return;
//            }

            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            NSString *strMsg ;
            //************************** 전체 해지&미가입 일 경우.
            if(isDissposal){
                strMsg=@"신한 올패스 가입 정보가 없습니다. 서비스를 다시 이용하시려면 가입 또는 등록을 해주시기 바랍니다.";
            }
            else{
                strMsg=@"신한 올패스 서비스 이용 정지 상태입니다. 서비스를 다시 이용하시려면 신한 올패스 이용 등록을 해주시기 바랍니다.";
            }

            //=================== 3. 통합인증서 정보가 없는 경우
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:strMsg
                                          preferredStyle:UIAlertControllerStyleAlert];


            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];

                                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",[_dicTestAppsShemes valueForKey:_otherAppSchemeCode]]];

                                     if( [[UIApplication sharedApplication] canOpenURL:url] == YES ){
                                         //================= 데이터를 보낸다.
                                         [[UIApplication sharedApplication] openURL:url];
                                     }else{
                                         //================= 설치되지 않았음. 앱스토어로 이동
                                         NSString *strMsg=[NSString stringWithFormat:@"%@ 스토어 이동",[_dicTestAppName valueForKey:_otherAppSchemeCode]];
                                         RUN_ALERT_PANEL( strMsg  ) ;
                                     }

                                 }];

            [alert addAction:ok];
            [rootController presentViewController:alert animated:YES completion:nil];

        }
//        SHICSSOManager *ssoManager = [[SHICSSOManager alloc] init];
//        ssoManager.delegate=self;
//        [ssoManager requestSSO:@"" setCode:@"" setTarget:@""];
    }
    else{
        RUN_ALERT_PANEL(@"로그인이 필요합니다.");
    }
}

#pragma FidoTranjectionDelegate
- (void)inquireResult:(FidoTransaction*)fidoTransaction
{
//    NSLog(@"inquireResult : <><><> %@ <><><>",resultData);

    if(fidoTransaction.isOK){

        /*
         {
         "dataBody": {
         "icData": {
         "expiryDate": "20210619",
         "icId": "812b238915365b66b4af84c058461f03b92b615d1841d69a929fb23166c77354",
         "realNm": "후수천",
         "regDate": "20180619160924",
         "lock": false,
         "stateCode": "1",
         "cntAuthFail": 0,
         "affiliatesCodes": {
         "001": "1",
         "002": "1"
         }
         },
         "resultCode": "000",
         "resultMsg": "success"
         },
         "dataHeader": {
         "resultCode": "000",
         "resultMessage": "조회가 완료되었습니다.",
         "category": "",
         "successCode": "0"
         }
         }
         */

        //=============== 통합인증서 정상 상태 조회
        if([fidoTransaction.rtnicData[@"stateCode"] isEqualToString:SERVERCODE_AFFILIATESCODES_SUC]){
            _affiliatesCodes = fidoTransaction.rtnicData[@"affiliatesCodes"];
            [self initAppList:_affiliatesCodes];
        }
        //============= 정상아닐 경우 모든 그룹사 인증서 상태 비활성화.
        else{
            isDissposal=YES;;
            [self initAppList:nil];
        }
    }
    else{
        [self initAppList:nil];
//        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
        [CertificateManager checkRequestFido:fidoTransaction];
    }

}

- (void)fidoResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){
//        NSMutableDictionary *userInfo= [UserInfo getUserInfo];
//        NSString* icid = [userInfo objectForKey:KEY_ICID];

        NSString* queryStr = [NSString stringWithFormat:@"%@://?host=%@&affiliatesCode=%@&&ssoData=%@",
                              [_dicTestAppsShemes valueForKey:_otherAppSchemeCode],
                              [_dicTestAppHost objectForKey:_otherAppSchemeCode],
                              fidoTransaction.rtnResultData[@"dataBody"][@"affiliatesCode"],
                              fidoTransaction.rtnResultData[@"dataBody"][@"ssoData"]
                              ];

        
        /*
         iphoneSbank://?affiliatesCode=그룹사코드&ssoData=sso데이터&ssoTime=System.currentTimeMillis()

         "'AppScheme'://?'openURL구분값'&ssoData='SSo해쉬값'&affiliatesCode='그룹사상태정보'&goPage='이동화면구분값'"
         AppScheme : 앱의 Shcheme ID
         선택  : openURL구분값 : OpenUrl 시 통합인증에 대한 OpenURL 구분 값 (AppDelegate openURL에서 통합인증 하기 위한 요청인지 구분 : 그룹사별 정의 필요)
         필수 :  SSo해쉬값 : 서버에서 생성된 SSO 검증 데이터. (통합인증 서버에서 받는 Data)
         필수 : affiliatesCode : 그룹사 상태 정보 (서버 검증용) (1 : 정상, 2 : 해지, 3 : 정지 - 코드표 stateCode값과 동일) (통합인증 서버에서 받는 Data)
         선택 : 이동화면구분값 : OpenUrl 이후 이동 될 화면 번호? 데이터 (각 그룹사별 이동해야 하는 페이지 필요시 : 그룹사별 정의 필요)
         */


        NSURL *url = [NSURL URLWithString:queryStr];

        if( [[UIApplication sharedApplication] canOpenURL:url] == YES ){
            //================= 데이터를 보낸다.
            [[UIApplication sharedApplication] openURL:url];
        }else{
            //================= 설치되지 않았음. 앱스토어로 이동
            NSString *strMsg=[NSString stringWithFormat:@"%@ 스토어 이동",[_dicTestAppName valueForKey:_otherAppSchemeCode]];
            RUN_ALERT_PANEL( strMsg  ) ;
        }
    }
    else{
//        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
        [CertificateManager checkRequestFido:fidoTransaction];
    }
}

#pragma SHICSSOManager Delegate
-(void)doOpenURL:(NSString*)strSamlToken
{
    //1. 해당 그룹사 OAuth서버로부터 SSO정보를 취득한다.
    //2. 취득한 SSO정보를 라이브러리에서 제공하는 API를 이용하여 암호화한다.
    //3. 암호화 한 SSO정보를 링크하고자 하는 앱의 스키마뒤에 Base64 인코딩해서 정보를 넘긴다.
    NSData* encodingData = [strSamlToken dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64Data = [encodingData base64EncodedString];
    NSString* queryStr = [NSString stringWithFormat:@"%@data?%@&goPage=%@",[_dicTestAppsShemes valueForKey:_otherAppSchemeCode], base64Data,@"test"];
    NSURL *url = [NSURL URLWithString:queryStr];

    if( [[UIApplication sharedApplication] canOpenURL:url] == YES ){
        //데이터를 보낸다.
        [[UIApplication sharedApplication] openURL:url];
    }else{
        // 설치되지 않았음. 링크 페이지로 전환
    }
}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
