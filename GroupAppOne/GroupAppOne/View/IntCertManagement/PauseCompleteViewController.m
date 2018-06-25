//
//  PauseCompleteViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "PauseCompleteViewController.h"

@interface PauseCompleteViewController ()

@end

@implementation PauseCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"신한 올패스 정지 완료";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:NO isRightMenu:NO];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICEPAUSEFINISH];
}

//AutoLayout 제약조건 적용 후 WebViewLoad
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Event

-(IBAction)confirmBtnTouchUpInsaide:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
