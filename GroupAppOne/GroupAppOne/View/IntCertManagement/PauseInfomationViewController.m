//
//  PauseInfomationViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import "PauseInfomationViewController.h"
#import "PasswordViewController.h"
#import <UIKit/UIView.h>
#import "IntergratedCertificationViewController.h"

@interface PauseInfomationViewController ()<UIAlertViewDelegate>

@end

@implementation PauseInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title=@"신한 올패스 정지 안내";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICEPAUSE];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pauseTouchUpInside:(id)sender {
    
    BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN];
    // 통합인증 로그인되어 있는 상태는 통합인증 로그인 수단으로 본인절자 진행
    if(isLogin){
        IntergratedCertificationViewController* intCertViewController = [[IntergratedCertificationViewController alloc] init];
        //정지를 위한 인증방식을 셋팅
        [intCertViewController callTypeSet:CallTypePause];
        [self.navigationController pushViewController:intCertViewController animated:YES];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:@"통합인증서비스를 이용 정지하시려면\n로그인 해주시기 바랍니다."
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
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 //로그인화면으로
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                             }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma uiAlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    IntergratedCertificationViewController* intCertViewController = [[IntergratedCertificationViewController alloc] init];
    [self.navigationController pushViewController:intCertViewController animated:YES];
}
@end
