//
//  PWResetCompleteViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "PWResetCompleteViewController.h"


@interface PWResetCompleteViewController()


@end
@implementation PWResetCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title=@"신한통합인증 비밀번호 재설정";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:NO isRightMenu:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confiromTouchUpInside:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

