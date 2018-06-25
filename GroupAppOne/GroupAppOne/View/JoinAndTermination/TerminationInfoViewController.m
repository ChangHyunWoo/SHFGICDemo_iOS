//
//  TerminationInfoViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "TerminationInfoViewController.h"
#import "AuthorizationViewController.h"

@interface TerminationInfoViewController ()

@end

@implementation TerminationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"신한 올패스 해지 안내";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 신한 올패스 해지 버튼 액션
- (IBAction)teminationTouchUpInside:(id)sender{
    //To-do
    //각 그룹사의 본인인증 수단의 화면을 호출한다.
    
    AuthorizationViewController* authViewController = [[AuthorizationViewController alloc] init];
    [self.navigationController pushViewController:authViewController animated:YES];
    
}

@end
