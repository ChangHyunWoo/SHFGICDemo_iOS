//
//  DisposalSelectViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "DisposalSelectViewController.h"
#import "DisposalInfomationViewController.h"
#import "PauseInfomationViewController.h"
#import "PasswordViewController.h"

@interface DisposalSelectViewController ()

//이용정지 설명은 앱명 으로 수정 필요***
@property (weak, nonatomic) IBOutlet UILabel *btnPauseComment;

@end

@implementation DisposalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title=@"신한 올패스 해지/정지";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disposalTouchUpInside:(id)sender {
    DisposalInfomationViewController* disposalViewController = [[DisposalInfomationViewController alloc] init];
    [self.navigationController pushViewController:disposalViewController animated:YES];
}
- (IBAction)pauseTouchUpInside:(id)sender {
    PauseInfomationViewController* pauseViewController = [[PauseInfomationViewController alloc] init];
    [self.navigationController pushViewController:pauseViewController animated:YES];
}

@end
