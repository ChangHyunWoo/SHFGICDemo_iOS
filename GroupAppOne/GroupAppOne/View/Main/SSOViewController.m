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
    NSString* _otherAppScheme;
    NSDictionary *_affiliatesCodes;
    NSDictionary *_dicTestApps;
    NSDictionary *_dicTestAppsShemes;
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



//    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]) {
//        NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
//    }
    _dicTestApps = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"GroupAppOne",@"001",
                    @"GroupAppOne2",@"002",
                    @"GroupAppOne3",@"003"
                    , nil];

    _dicTestAppsShemes = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"demoApp",@"001",
                    @"demoApp2",@"002",
                    @"demoApp3",@"003"
                    , nil];


    /*=================== 그룹사 앱 목록 Init.
     * 상태별 아이콘 명
     * ico_sso_login_dis.png
     * ico_sso_login.png
     */
    self.otherLbl.text = [[_dicTestApps allValues] objectAtIndex:0];
    self.otherLbl2.text = [[_dicTestApps allValues] objectAtIndex:1];
    self.otherLbl3.text = [[_dicTestApps allValues] objectAtIndex:2];

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
    for(NSString *strCode in [dicAffiliatesCodes allKeys]){
        if([strCode isEqualToString:[[_dicTestApps allKeys] objectAtIndex:0]]){
            [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState];
        }
        else if([strCode isEqualToString:[[_dicTestApps allKeys] objectAtIndex:1]]){
            [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState2];
        }
        else if([strCode isEqualToString:[[_dicTestApps allKeys] objectAtIndex:2]]){
            [self updateIcon:[dicAffiliatesCodes objectForKey:strCode] setButton:_otherState3];
        }
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
    //************************** 전체 해지 일 경우.
    if(isDissposal){
        RUN_ALERT_PANEL(@"신한통합인증 상태가 해지상태 입니다.");
        return;
    }

    BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN];
    /*
     링크하고자 하는 그룹사앱의 가입여부를 판단
     2번 정지일 경우만 정지 메시지 팝업, 미가입/가입상태는 해당 앱에 보낸 후 가입/로그인 절차 진행
     */
    BOOL isServiceOn = YES;

    if([sender tag] == 0){
        _otherAppScheme=[_dicTestAppsShemes objectForKey:[[_dicTestApps allKeys] objectAtIndex:0]];
        if([[_affiliatesCodes objectForKey:[[_dicTestApps allKeys] objectAtIndex:0] ] isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
            isServiceOn=NO;
        }
    }
    else if([sender tag] == 1){
        _otherAppScheme=[_dicTestAppsShemes objectForKey:[[_dicTestApps allKeys] objectAtIndex:1]];
        if([[_affiliatesCodes objectForKey:[[_dicTestApps allKeys] objectAtIndex:1]] isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
            isServiceOn=NO;
        }
    }
    else if([sender tag] == 2){
        _otherAppScheme=[_dicTestAppsShemes objectForKey:[[_dicTestApps allKeys] objectAtIndex:2]];

        if([[_affiliatesCodes objectForKey:[[_dicTestApps allKeys] objectAtIndex:2]] isEqualToString:SERVERCODE_AFFILIATESCODES_PAUSE]){
            isServiceOn=NO;
        }
    }
    else{
        isServiceOn=NO;
    }

    //===================== 현재앱을 선택 했다면 Return
    NSString* bundleID=[[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];

    if( [ bundleID isEqualToString:_otherAppScheme]){
        return;
    }

    //통합인증 로그인 및 링크앱의 서비스 가입여부가 YES일 경우만 SSO를 진행한다.
    if(isLogin){
        if(isServiceOn){
            FidoTransaction *tranjection = [[FidoTransaction alloc] init];
            tranjection.delegate=self;
            [tranjection requestSSOData];
        }
        else{
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;

            //=================== 3. 통합인증서 정보가 없는 경우
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:@"신한통합인증 서비스 이용 정지 상태입니다. 서비스를 다시 이용하시려면 신하통합인증 이용 등록을 해주시기 바랍니다."
                                          preferredStyle:UIAlertControllerStyleAlert];


            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     //================= 설치되지 않았음. 앱스토어로 이동
                                     NSString *strMsg=[NSString stringWithFormat:@"%@ 스토어 이동",_otherAppScheme];
                                     RUN_ALERT_PANEL( strMsg  ) ;

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
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }

}

- (void)fidoResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){

        NSMutableDictionary *userInfo= [UserInfo getUserInfo];
        NSString* icid = [userInfo objectForKey:KEY_ICID];
        NSString* queryStr = [NSString stringWithFormat:@"%@://?%@&ssoData=%@&affiliatesCode=%@&goPage=%@",
                              _otherAppScheme,
                              SSOSCHEMSKEY,
                              fidoTransaction.rtnResultData[@"dataBody"][@"ssoData"],
                              fidoTransaction.rtnResultData[@"dataBody"][@"affiliatesCode"],
                              @"test"];
        /*
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
            NSString *strMsg=[NSString stringWithFormat:@"%@ 스토어 이동",_otherAppScheme];
            RUN_ALERT_PANEL( strMsg  ) ;
        }
    }
    else{
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
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
    NSString* queryStr = [NSString stringWithFormat:@"%@data?%@&goPage=%@",_otherAppScheme, base64Data,@"test"];
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
