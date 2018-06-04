//
//  DisposalInfomationViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import "ElectronicSignatureViewController.h"
#import "SecuKeyPad.h"



#import <public_onepass/OnePassManager.h>
#import <public_onepass/OnePassDefine.h>

@interface ElectronicSignatureViewController ()<UIAlertViewDelegate,SecuKeypadDelegate,FidoTransactionDelegate>
{
    SecuKeyPad *keyPad;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFingerInput;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet UITextView *txtviewContent;

@end

@implementation ElectronicSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title=@"신한통합인증 해지 안내";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];

    keyPad = [[SecuKeyPad alloc] initView:self.viewKeyOutput];
    keyPad.secuKeypadDelegate = self;
    [keyPad initBaseView:self.viewContents];

    [D_CA setButtonBorder:_btnFingerInput setBorderColor:@"#dddddd"];
    [D_CA setButtonBorder:_btnCancel setBorderColor:@"#161c34"];
    [D_CA setButtonBorder:_btnConfirm setBorderColor:@""];

    //로그인시 셋팅된 서명데이터 불러옴.
    self.txtviewContent.text = D_CA.getUserInfo.ElectronicSignData;

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(contentViewTouchupInside:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [keyPad hideKeypad];
}

- (IBAction)fingerInputTouchInside:(id)sender
{
    [keyPad hideKeypad];
    [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForElectronicSign forKey:@"REQUEST_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserInfo checkFingerRegist:self setDelegate:self];
}

- (IBAction)cancelBtnInputTouchInside:(id)sender
{

}
- (IBAction)confirmBtnInputTouchInside:(id)sender
{

}

- (void)contentViewTouchupInside:(UITapGestureRecognizer *)recognizer
{
    [keyPad hideKeypad];
}

#pragma mark - SecuKeyPadDelegate
-(void)secuKeypadReturn:(NSString*)strInputKey
{
    NSLog(@"secuKeypadReturn : %@",strInputKey);

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.checkPassword1=strInputKey;

    [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForElectronicSign forKey:@"REQUEST_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    transaction.verifyType=SERVERCODE_VERIFYTYPE_PIN;
    [transaction requestFido:FidoCommandForElectronicSign];

}

#pragma mark - FidoTransactionDelegate
- (void)fidoResult:(FidoTransaction*)fidoTransaction{
    NSLog(@"fidoResult : <><><> %@ <><><>",fidoTransaction.rtnResultData);

    if(fidoTransaction.isOK){
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.verifyType = fidoTransaction.verifyType; // 현재 verifyType 핀,지문 을 Confirm에서 확인 후 Sign 시 Verify값을 전달하기 위해 Set.
        transaction.delegate = self;
        [transaction requestFidoConfirm:(FidoCommandType)requestType];
    }
    else{
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
}

- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        //================= 전자서명 완료
        if(requestType == FidoCommandForElectronicSign){
            RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
        }
    }
    else{
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
}
@end
