//
//  AuthorizationViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import "AuthorizationViewController.h"
#import "AddAuthorizationViewController.h"
#import "PasswordViewController.h"
#import "TermsViewController.h"

#define USERCI_LIMITLENG 88

@interface AuthorizationViewController ()<FidoTransactionDelegate,UIAlertViewDelegate,UITextViewDelegate>{
    NSMutableArray* _pickerElements;
}
@property(nonatomic, strong) IBOutlet UIButton* selectUserBtn;
@property(nonatomic, strong) IBOutlet UILabel* userLbl;
@property (weak, nonatomic) IBOutlet UITextView *ciTxtv;
@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomSpace;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"휴대폰 본인인증";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];
    
    _pickerElements       = [[NSMutableArray alloc] init];



    //*********** 비밀번호 찾기 시 선택된 이름정보 불러오기 or 유저선택 비활성화.
    if([self.viewType isEqualToString:AUTHORIZATIONVIEWTYPE_PASSWORDSEARCH]){
        _selectUserBtn.enabled=NO;//유저선택 비활성화.

        NSString* string = [[SHICUser defaultUser] get:KEY_NAME];
        NSString* title = [NSString stringWithFormat:@"%@", string];
        self.userLbl.text =  [NSString stringWithFormat:@"%@[%ld]",title,[[D_CA getUserInfo] getUserCI:string].length];
        self.ciTxtv.text = [[D_CA getUserInfo] getUserCI:string];
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:string forKey:@"testUser"];
        [userDefault synchronize];

        [[SHICUser defaultUser] put:KEY_CI value:[[ D_CA getUserInfo] getUserCI:string]];
        [[SHICUser defaultUser] put:KEY_NAME value:string];
    }
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
    //각 그룹사의 본인인증후의 CI 값을 셋팅한 후 약관화면으로 이동
    if([self.ciTxtv.text length] != USERCI_LIMITLENG){
        NSString *strMsg = [NSString stringWithFormat:@"[%d]길이를 입력해 주세요.",USERCI_LIMITLENG] ;
        RUN_ALERT_PANEL(strMsg);
        return;
    }
    
    //통합인증 서비스 가입상태 조회
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    if([self.viewType isEqualToString:AUTHORIZATIONVIEWTYPE_PASSWORDSEARCH]){
        [transaction verifyCertification:[[SHICUser defaultUser] get:KEY_ICID] type:FidoVerifyPasswordChangeAuth];
    }
    else{
        [transaction verifyCertification:[[SHICUser defaultUser] get:KEY_CI] type:FidoVerifyInquire];
    }
    
    
}
- (IBAction)selectUserTouchUpInside:(id)sender{
    _pickerElements       = [[NSMutableArray alloc] init];
    
    //UserInfo의 테스트 데이터 List (UesrName) Init
    for(NSString *strName in [[D_CA getUserInfo] getUserList]){
        [_pickerElements addObject:strName];
    }

    self.pickerView.tag = 100;
    
    [self.pickerView reloadAllComponents];
    self.pickerViewBottomSpace.constant = 0;
    [self.view layoutIfNeeded];
    
}

#pragma TextviewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString* string = [[SHICUser defaultUser] get:KEY_NAME];
    NSString* title = [NSString stringWithFormat:@"%@", string];
    self.userLbl.text = [NSString stringWithFormat:@"%@[%ld]",title,textView.text.length];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //newLineCharacterSet이 있으면 done button이 호출됨. 따라서 키보드가 사라짐.
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;

    //텍스트가 88자가 넘지 않도록 제한
    if (textView.text.length + text.length > USERCI_LIMITLENG){
        if (location != NSNotFound){
            [textView resignFirstResponder];;
        }
        return NO;
    }

    if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

#pragma mark -pickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerElements count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerElements[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
- (IBAction)pickerCancel:(id)sender {
    self.pickerViewBottomSpace.constant = -260;
    [self.view layoutIfNeeded];
}

- (IBAction)pickerDone:(id)sender {
    self.pickerViewBottomSpace.constant = -260;
    [self.view layoutIfNeeded];
    
    switch (self.pickerView.tag) {
            
        case 100 : {
            NSString* string = _pickerElements[[self.pickerView selectedRowInComponent:0]];
            NSString* title = [NSString stringWithFormat:@"%@", string];
            self.userLbl.text =  [NSString stringWithFormat:@"%@[%ld]",title,[[D_CA getUserInfo] getUserCI:string].length];
            self.ciTxtv.text = [[D_CA getUserInfo] getUserCI:string];
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:string forKey:@"testUser"];
            [userDefault synchronize];
            
           [[SHICUser defaultUser] put:KEY_CI value:[[ D_CA getUserInfo] getUserCI:string]];
           [[SHICUser defaultUser] put:KEY_NAME value:string];
        }break;
            
        default:
            break;
    }
    
    
}
- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)dataBody{
    if(isOK){

        //******************** 비밀번호 찾기 시 추가 인증으로 이동.
        if([self.viewType isEqualToString:AUTHORIZATIONVIEWTYPE_PASSWORDSEARCH]){
            [CertificateManager checkicDataRegist:dataBody[@"icData"] setCommand:CertificateManageCommandTypeSearchPassword];
        }
        else{
            [CertificateManager checkicDataRegist:dataBody[@"icData"] setCommand:CertificateManageCommandTypeRegist];
        }
    }
    else{
        RUN_ALERT_PANEL(msg);
    }
}

#pragma uiAlertView Delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag){
        case 100:
            break;
        case 200:
        {
            if(buttonIndex == 1){
                [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserRe_Regist forKey:@"REQUEST_TYPE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //핀인증 화면으로 이동
                    PasswordViewController* passViewController = [[PasswordViewController alloc] init];
                    passViewController.viewType = PASSWORDVIEWTYPE_CONFIRM;
                    [self.navigationController pushViewController:passViewController animated:YES];
                });


            }
        } break;
    }

}

@end
