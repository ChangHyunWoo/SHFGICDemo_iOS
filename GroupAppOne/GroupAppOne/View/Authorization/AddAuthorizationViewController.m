//
//  AddAuthorizationViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import "AddAuthorizationViewController.h"
#import "TermsViewController.h"
#import "PasswordViewController.h"

@interface AddAuthorizationViewController ()<FidoTransactionDelegate,UIAlertViewDelegate>{

}
@end

@implementation AddAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"추가 본인인증";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];
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
#pragma mark - 본인인증 확인 버튼 액션
- (IBAction)confirmTouchUpInside:(id)sender{
    //To-do
    //각 그룹사의 다른 로그인방식으로 취득한 CI 값을 검증후 약관화면으로 이동
    // 비로그인시에는 본인인증 화면에서 CI값을 검증하고 있음.
    BOOL isLoginOther = [[SHICUser defaultUser] isLoginOther];

    if([self.viewType isEqualToString:AUTHORIZATIONVIEWTYPEADD_PASSWORDSEARCH]){
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        [transaction verifyCertification:[[SHICUser defaultUser] get:KEY_ICID] type:FidoVerifyPasswordChangeAuth];
    }
    else if(isLoginOther){
        //통합인증 서비스 가입상태 조회
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        [transaction verifyCertification:[[SHICUser defaultUser] get:KEY_CI] type:FidoVerifyInquire];
    }
    else{
        TermsViewController * termsViewController = [[TermsViewController alloc] init];
        [self.navigationController pushViewController:termsViewController animated:YES];
    }
}

- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)dataBody{
    if(isOK){
        //******************** 비밀번호 찾기 시 추가 인증으로 이동 .
        if([self.viewType isEqualToString:AUTHORIZATIONVIEWTYPEADD_PASSWORDSEARCH]){
            [CertificateManager checkicDataRegist:dataBody[@"icData"] setCommand:CertificateManageCommandTypeSearchPassword2];
        }
        else{
            [CertificateManager checkicDataRegist:dataBody[@"icData"] setCommand:CertificateManageCommandTypeRegist];
        }
    }
    else{
        RUN_ALERT_PANEL(msg);
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
