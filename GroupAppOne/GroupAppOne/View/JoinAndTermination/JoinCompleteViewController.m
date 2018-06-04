//
//  JoinCompleteViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "JoinCompleteViewController.h"

@interface JoinCompleteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@end

@implementation JoinCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"가입완료";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:NO isRightMenu:YES];

    [D_CA setButtonBorder:_btnConfirm setBorderColor:@""];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICEREGISTCOMPLETE];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirmBtnTouchUpInside:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
