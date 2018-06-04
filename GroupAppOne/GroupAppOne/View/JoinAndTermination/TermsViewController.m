//
//  TermsViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "TermsViewController.h"
#import "PasswordViewController.h"

@interface TermsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"약관 및 이용동의";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];

    [D_CA setButtonBorder:_btnCancel setBorderColor:@"#161c34"];
    [D_CA setButtonBorder:_btnConfirm setBorderColor:@""];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICEEULA];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (IOS_VERSION_GREATER_THAN(11) && IS_IPHONE_X){
        /***** TopLayout / BottomLayou GuideViewHeight *****/
//        [_viewTopLayoutHeightConstraint setConstant:self.topLayoutGuide.length ];
        [_viewBottomLayoutHeightConstraint setConstant: self.bottomLayoutGuide.length ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 취소/확인 버튼 액션
- (IBAction)cancelTouchUpInside:(id)sender{
    //To-do
    //취소시의 처리
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"알림"
                                 message:@"신한통합인증 서비스 가입을 취소하시겠습니까?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* cancelButton = [UIAlertAction
                               actionWithTitle:@"취소"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];

    UIAlertAction* confirmButton = [UIAlertAction
                                actionWithTitle:@"확인"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    //[self clearAllData];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }];
    
    
    //Add your buttons to alert controller
    
    [alert addAction:cancelButton];
    [alert addAction:confirmButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (IBAction)confirmTouchUpInside:(id)sender{
    //To-do
    //약관동의 후 통합인증 비밀번호 입력화면으로 이동한다.
    
    PasswordViewController* pwViewController = [[PasswordViewController alloc] init];
    [self.navigationController pushViewController:pwViewController animated:YES];
    
}

@end
