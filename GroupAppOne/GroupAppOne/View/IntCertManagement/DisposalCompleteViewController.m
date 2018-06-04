//
//  DisposalCompleteViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "DisposalCompleteViewController.h"

@interface DisposalCompleteViewController ()

@end

@implementation DisposalCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"신한통합인증 해지 완료";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:NO isRightMenu:NO];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICEDISPOSALFINISH];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirmBtnTouchUpInsaide:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
