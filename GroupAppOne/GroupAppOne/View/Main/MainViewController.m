//
//  MainViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 1. 25..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "TermsViewController.h"


#import <IntergratedCertification/IntergratedCertification.h>
#import "MainViewController.h"
#import "MainNavigationController.h"

#import "InformationUseViewController.h"
#import "TerminationInfoViewController.h"
#import "IntCertManagementViewController.h"
#import "IntergratedCertificationViewController.h"
#import "ElectronicSignatureViewController.h"
#import "SSOViewController.h"


#define _TAG_PICKER_APP         1000
#define _TAG_PICKER_CONTENTS    1001
#define _TAG_PICKER_API         1002
#define _TAG_PICKER_USER        1003
#define _TAG_PICKER_MODE        1004
#define _TAG_PICKER_LOGIN       1005

@interface MainViewController (){
    NSMutableArray* _pickerElements;
}

@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *appButton;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *loginSwitch;

@end



@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"데모용앱(CLOUD)" forKey:@"appName"];
    [userDefault setObject:@"TEST" forKey:@"devMode"];
    [userDefault synchronize];

    [MainViewController updateProperty];

//    SHICProperty *property = [SHICProperty ]
//
//    NSMutableString* string = [NSMutableString string];
//    [string appendFormat:@"devMode    : %@\n", (property.isReal?@"REAL":@"TEST")];
//    [string appendFormat:@"subChannel : %@\n", property.subChannel];
//    [string appendFormat:@"domain     : %@\n", (property.isReal?property.domainForService:property.domainForDevelopment)];
//    //    [string appendFormat:@"bank       : %@\n", contents[KEY_BANK]];
//    //    [string appendFormat:@"card       : %@\n", contents[KEY_CARD]];
//    //    [string appendFormat:@"investment : %@\n", contents[KEY_INVEST]];
//    //    [string appendFormat:@"insurance  : %@\n", contents[KEY_INSURANCE]];
//    //    [string appendFormat:@"fanclub    : %@\n", contents[KEY_FANCLUB]];
//    //    [string appendFormat:@"uselocal   : %@\n", (property.uselocalSystemFile?@"YES":@"NO")];
//    [string appendFormat:@"name       : %@\n", [[SHICUser defaultUser] get:KEY_NAME]];
//    [string appendFormat:@"CI         : %@[%ld]\n", [[SHICUser defaultUser] get:KEY_CI],[[[SHICUser defaultUser] get:KEY_CI] length] ];
//
//    self.textView.text = string;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginSwitch addTarget: self action: @selector(switchFlip:) forControlEvents: UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"MAIN";
    
    _pickerElements       = [[NSMutableArray alloc] init];
    
    [_pickerElements addObject:@"데모용앱(CLOUD)"];
    [_pickerElements addObject:@"신한은행(SOL)"];
    [_pickerElements addObject:@"신한카드(FAN)"];
    [_pickerElements addObject:@"신한금투(i알파)"];
    [_pickerElements addObject:@"신한생명(스마트창구)"];

    NSString *firstName = [[[D_CA getUserInfo] getUserList] objectAtIndex:0];
    [self.userButton setTitle:firstName forState:UIControlStateNormal];
    [[SHICUser defaultUser] put:KEY_NAME value:firstName];
    [[SHICUser defaultUser] put:KEY_CI value:[[D_CA getUserInfo] getUserCI:firstName] ];
    [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
    [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(NO)];


    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //로딩이 닫히지 않는 현상 해결 하기위해.
    [D_CA hideLoading];

    BOOL isLoginRequest = [[NSUserDefaults standardUserDefaults] boolForKey:@"INT_CERT_LOGIN"];
    if(isLoginRequest){
        IntergratedCertificationViewController* intCertViewController = [[IntergratedCertificationViewController alloc] init];
        [self.navigationController pushViewController:intCertViewController animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"INT_CERT_LOGIN"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    if([[SHICUser defaultUser] getBoolean:KEY_LOGIN]){
        self.loginButton.enabled = NO;
        self.logoutButton.enabled = YES;
    }
    else{
        self.loginButton.enabled = YES;
        self.logoutButton.enabled = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)modeButtonTouchUpInside:(id)sender {
    _pickerElements       = [[NSMutableArray alloc] init];
    
    [_pickerElements addObject:@"TEST"];
    [_pickerElements addObject:@"REAL"];
    
    if( [self.modeButton.titleLabel.text containsString:@"TEST"] ) {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    } else if( [self.modeButton.titleLabel.text containsString:@"REAL"] ) {
        [self.pickerView selectRow:1 inComponent:0 animated:NO];
    }
    
    self.pickerView.tag = _TAG_PICKER_MODE;
    
    [self.pickerView reloadAllComponents];
    self.pickerViewBottomSpace.constant = 0;
    [self.view layoutIfNeeded];
}
- (IBAction)appButtonTouchUpInside:(id)sender {
    _pickerElements       = [[NSMutableArray alloc] init];
    
    [_pickerElements addObject:@"데모용앱(CLOUD)"];
    [_pickerElements addObject:@"신한은행(SOL)"];
    [_pickerElements addObject:@"신한카드(FAN)"];
    [_pickerElements addObject:@"신한금투(i알파)"];
    [_pickerElements addObject:@"신한생명(스마트창구)"];
    
    
    if( [self.appButton.titleLabel.text isEqualToString:@"데모용앱(CLOUD)"] ) {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    } else if( [self.appButton.titleLabel.text isEqualToString:@"신한은행(SOL)"] ) {
        [self.pickerView selectRow:1 inComponent:0 animated:NO];
    } else if( [self.appButton.titleLabel.text isEqualToString:@"신한카드(FAN)"] ) {
        [self.pickerView selectRow:2 inComponent:0 animated:NO];
    } else if( [self.appButton.titleLabel.text isEqualToString:@"신한금투(i알파)"] ) {
        [self.pickerView selectRow:3 inComponent:0 animated:NO];
    } else if( [self.appButton.titleLabel.text isEqualToString:@"신한생명(스마트창구)"] ) {
        [self.pickerView selectRow:4 inComponent:0 animated:NO];
    }
    
    self.pickerView.tag = _TAG_PICKER_APP;
    
    [self.pickerView reloadAllComponents];
    self.pickerViewBottomSpace.constant = 0;
    [self.view layoutIfNeeded];
}
- (IBAction)userButtonTouchUpInside:(id)sender {
    _pickerElements       = [[NSMutableArray alloc] init];

    //UserInfo의 테스트 데이터 List (UesrName) Init
    for(NSString *strName in [[D_CA getUserInfo] getUserList]){
        [_pickerElements addObject:strName];
    }

    self.pickerView.tag = _TAG_PICKER_USER;
    
    [self.pickerView reloadAllComponents];
    self.pickerViewBottomSpace.constant = 0;
    [self.view layoutIfNeeded];
}
- (IBAction)pickerCancel:(id)sender {
    self.pickerViewBottomSpace.constant = -260;
    [self.view layoutIfNeeded];
}

- (IBAction)pickerDone:(id)sender {
    self.pickerViewBottomSpace.constant = -260;
    [self.view layoutIfNeeded];
    
    switch (self.pickerView.tag) {
        case _TAG_PICKER_APP : {
            NSString* app = _pickerElements[[self.pickerView selectedRowInComponent:0]];
            [self.appButton setTitle:app forState:UIControlStateNormal];
            
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:app forKey:@"appName"];
            [userDefault synchronize];
        }break;
            
        case _TAG_PICKER_MODE : {
            NSString* string = _pickerElements[[self.pickerView selectedRowInComponent:0]];
            NSString* title = [NSString stringWithFormat:@"Environment (%@)", string];
            [self.modeButton setTitle:title forState:UIControlStateNormal];
            
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:string forKey:@"devMode"];
            [userDefault synchronize];
        }break;

        case _TAG_PICKER_USER : {
            NSString* string = _pickerElements[[self.pickerView selectedRowInComponent:0]];
            NSString* title = [NSString stringWithFormat:@"%@", string];
            [self.userButton setTitle:title forState:UIControlStateNormal];
            
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:string forKey:@"testUser"];
            [userDefault synchronize];
            
            [[SHICUser defaultUser] put:KEY_CI value:[[D_CA getUserInfo] getUserCI:string]];
            [[SHICUser defaultUser] put:KEY_NAME value:string];
            [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
            [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(YES)];
            [self.loginSwitch setOn:YES];
            
            //[self.loginSwitch setOn:YES];
            
        }break;
            
        case _TAG_PICKER_LOGIN : {
//            NSString* string = _pickerElements[[self.pickerView selectedRowInComponent:0]];
        }break;
            
        default:
            break;
    }
    
    
    [MainViewController updateProperty];
}

#pragma mark -pickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerElements count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerElements[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

+ (void)updateProperty
{
    NSUserDefaults*     userDefault = [NSUserDefaults standardUserDefaults];
    SHICProperty*       property	= [[SHICProperty alloc] init];
    NSString* typeOfAPIServer       = @"TEST";
    
    property.logging                = YES;
    property.appName                = @"Demo";
    property.udid                   = @"Demo";
    
//    [[IntCertInterface sharedInstance] initialize:(void*)property];
    

    // 초기 정보 셋팅 //
    if( [userDefault objectForKey:@"devMode"] != nil )
        typeOfAPIServer = [userDefault objectForKey:@"devMode"];

    if ([typeOfAPIServer isEqualToString:@"TEST"]) {
        property.clientID               = @"l7xxb751af0803d649c1becdd24256bebfad";
        property.clientSecret           = @"b08b75437a0643b0ac233e00648e192f";
        property.isReal                 = NO;
    }else{
        property.clientID               = @"l7xx4833b57d423b4e76b780ce85397d7919";
        property.clientSecret           = @"e34cd82ee1b84a909ffe222872c9d713";
        property.isReal                 = YES;
    }

    NSString* app= @"데모용앱(CLOUD)";
    
    if( [userDefault objectForKey:@"appName"] != nil ){
        app = [userDefault objectForKey:@"appName"];
    }
    
    if( [app isEqualToString:@"데모용앱(CLOUD)"] ) {
        property.subChannel             = @"01";
        //property.talkChannelID          = @"CHNL9000000001";
#ifdef TEST_GROUP1
        property.domainForService       = SHIC_BIZ_SERVER;
        property.domainForDevelopment   = SHIC_BIZ_SERVER;
//        property.domainForService       = @"http://192.168.0.77:8080";
//        property.domainForDevelopment   = @"http://192.168.0.77:8080";
#else
        property.domainForService       = SHIC_BIZ_SERVER_2;
        property.domainForDevelopment   = SHIC_BIZ_SERVER_2;
//        property.domainForService       = @"http://192.168.0.228:8080";
//        property.domainForDevelopment   = @"http://192.168.0.228:8080";

#endif
        //property.privateTarget          = @"BANK";
    } else if( [app isEqualToString:@"신한은행(SOL)"] ) {
        property.subChannel             = @"02";
        //property.talkChannelID          = @"CHNL9000000001";
        property.domainForService       = SHIC_OAUTH_BANK;
        property.domainForDevelopment   = SHIC_OAUTH_DEV_BANK;
        //property.privateTarget          = @"BANK";
    } else if( [app isEqualToString:@"신한카드(FAN)"] ) {
        property.subChannel             = @"04";
        //property.talkChannelID          = @"CHNL9000000001";
        property.domainForService       = SHIC_OAUTH_CARD;
        property.domainForDevelopment   = SHIC_OAUTH_DEV_CARD;
        //property.privateTarget          = @"CARD";
    } else if( [app isEqualToString:@"신한금투(i알파)"] ) {
        property.subChannel             = @"21";
        //property.talkChannelID          = @"CHNL9000000001";
        property.domainForService       = SHIC_OAUTH_INVESTMENT;
        property.domainForDevelopment   = SHIC_OAUTH_DEV_INVESTMENT;
        //property.privateTarget          = @"INVESTMENT";
    } else if( [app isEqualToString:@"신한생명(스마트창구)"] ) {
        property.subChannel             = @"31";
        //property.talkChannelID          = @"CHNL9000000001";
        property.domainForService       = SHIC_OAUTH_INSURANCE;
        property.domainForDevelopment   = SHIC_OAUTH_DEV_INSURANCE;
        //property.privateTarget          = @"INSURANCE";
    }
    
    [[IntCertInterface sharedInstance] initialize:(void*)property];

}

- (IBAction)switchFlip:(id)sender{

    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(YES)];
        //[[UserCertInfo sharedSigleton] setValue:@(YES) forKey:USERKEY_LOGIN];


    } else{
        NSLog(@"Switch is OFF");
        [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(NO)];

    }

}

- (IBAction)testButtonTouchUpInside:(id)sender {
    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
    //[[SHSPIndicator defaultIndicator] showLoading];
    
    //tr.target = [IntCertInterface sharedInstance].property[@"domainForDevelopment"];
    NSLog(@"%@",  tr.target);
    
    [tr putValue:@"CI0000" forBody:@"ciNo"];
    [tr putValue:@"checkRegisteredStatus" forBody:@"command"];
    [tr putValue:@"SHG00000000000" forBody:@"siteId"];
    [tr putValue:@"SHG11111111111" forBody:@"svcId"];
    [tr putValue:@"userId" forBody:@"loginId"];
    [tr putValue:@"gYJKoZIhvcNAQcCoIIH7zCCB+sCAQExDzANBglghkg==" forBody:@"deviceId"];
    [tr putValue:@"android:apk-key-hash:Df+2X53Z0UscvUu6obxC3rIfFyk" forBody:@"appId"];
    [tr putValue:@"8191" forBody:@"verifyType"];
    
   
    [tr transmitWithFinished:^(SHICTransaction *tr) {
        //[[SHSPIndicator defaultIndicator] hideLoading];
        NSLog(@"%@",  tr.responseBody);
        
    } failed:^(SHICTransaction *tr) {
        // [tr.error localizedDescription];
        //[[SHSPIndicator defaultIndicator] hideLoading];
        NSLog(@"%@",  tr.error);
    } cancel:^(SHICTransaction *tr) {
        
        //[[SHSPIndicator defaultIndicator] hideLoading];
        NSLog(@"cancel");
    }];
}

#pragma mark - join
- (IBAction)joinAndTeminationTouchUpInside:(id)sender{
    //To-do : 가입여부 판단해야함.
    BOOL isJoin = NO;

    //미가입이면 가입으로
    if(!isJoin){
        InformationUseViewController* infoUseViewController = [[InformationUseViewController alloc] init];
        [self.navigationController pushViewController:infoUseViewController animated:YES];
    }//가입이면 해지로
    else{
        //우선은 팝업을 띄운다.
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:@"이미 통합안증 서비스에 가입된 사용자입니다. "
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        
        [message show];
//        TerminationInfoViewController* termiInfoViewController = [[TerminationInfoViewController alloc] init];
//        [self.navigationController pushViewController:termiInfoViewController animated:YES];
        
    }
}
#pragma mark - SSO
- (IBAction)ssoTouchUpInside:(id)sender{
    SSOViewController* ssoViewController =[[SSOViewController alloc] init];
    [self.navigationController pushViewController:ssoViewController animated:YES];
}
#pragma mark - 통합인증서 관리
- (IBAction)settingTouchUpInside:(id)sender
{
    //To-do : 가입여부 판단해야함.
    IntCertManagementViewController* settingViewController = [[IntCertManagementViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

#pragma mark - 로그인
- (IBAction)loginTouchUpInside:(id)sender{
    //To-do :
//    _pickerElements       = [[NSMutableArray alloc] init];
//    for(NSString *strName in [[D_CA getUserInfo] getUserList]){
//        [_pickerElements addObject:strName];
//    }
//
//    self.pickerView.tag = _TAG_PICKER_LOGIN;
//
//    [self.pickerView reloadAllComponents];
//    self.pickerViewBottomSpace.constant = 0;
//    [self.view layoutIfNeeded];
    if([UserInfo getUserInfo]){
        IntergratedCertificationViewController* intCertloginViewController = [[IntergratedCertificationViewController alloc] init];
        [self.navigationController pushViewController:intCertloginViewController animated:YES];
    }
    else{
        RUN_ALERT_PANEL(@"통합인증서비스에 가입되어 있지 않습니다.");
    }


}

- (IBAction)logoutTouchUpInside:(id)sender{
    //To-do : 로그아웃 처리.
    [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
    [[SHICUser defaultUser] put:KEY_CI value:@""];
    [[SHICUser defaultUser] put:KEY_NAME value:@""];
    [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
    [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(NO)];
    self.loginButton.enabled = YES;
    self.logoutButton.enabled = NO;
    //우선은 팝업을 띄운다.
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                      message:@"로그아웃 되었습니다. "
                                                     delegate:nil
                                            cancelButtonTitle:@"확인"
                                            otherButtonTitles:nil];
    
    [message show];
    
}


#pragma 전자서명
- (IBAction)electronicSignTouchupInside:(id)sender {
    // FIDO SDK 지연으로 임시로 막음.
//    RUN_ALERT_PANEL(@"준비 중 입니다.");
//    return;

    // 미 로그인 진입 불가
    if(![[SHICUser defaultUser] getBoolean:KEY_LOGIN]){
        RUN_ALERT_PANEL(@"로그인이 필요 합니다.");
        return;
    }
    
    ElectronicSignatureViewController* signView = [[ElectronicSignatureViewController alloc] init];
    [self.navigationController pushViewController:signView animated:YES];
}


@end
