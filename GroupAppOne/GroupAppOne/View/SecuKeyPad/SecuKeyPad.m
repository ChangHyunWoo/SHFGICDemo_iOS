//
//  NSObject+SecuKeyPad.m
//  GroupAppOne
//
//  Created by INBEOM on 2018. 3. 2..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "SecuKeyPad.h"

@interface SecuKeyPad ()<TransKeyDelegate, LockNumberViewDelegate>

@end


NSString *strPassword;
NSString *numberChiperString;       // transkey 암호화 값 설정
float _basePostionY=0; // 원본 포지션값 저장용

TransKey *pwTKField;
TransKey *checkField;               // 포커스된 transkey field copy
//LockNumberView *vLockNumberPassword;
LockNumberView *_lockView;


@implementation SecuKeyPad


- (void)dealloc
{
    [self hideKeypad];
}

-(SecuKeyPad*)initView:(UIView*)outputView
{
    /*
     InputBox Init
     */
    _lockView = [[LockNumberView alloc] initWithFrame:CGRectMake(0, 0, outputView.frame.size.width, outputView.frame.size.height)];
    _lockView.backgroundColor=outputView.backgroundColor;// 백그라운드 컬러 맞춤.
    _lockView.delegate=self;

    [outputView addSubview:_lockView];

    /*
     Keypad Init
     */
    pwTKField = [[TransKey alloc] initWithFrame:CGRectMake(10, 10, outputView.frame.size.width , outputView.frame.size.height)];
    pwTKField.delegate = self;

    //세큐리티키 설정(임시)
    unsigned char iv[16] = {'M', 'o', 'b', 'i', 'l', 'e', 'T', 'r' , 'a', 'n', 's', 'K', 'e', 'y', '1', '0' };
    NSData *gSecureKey = [[NSData alloc] initWithBytes:iv length:16];

    [pwTKField setSecureKey:gSecureKey];
    [pwTKField mTK_SupportedByDeviceOrientation:SupportedByDevicePortrait];
    [pwTKField setKeyboardType:TransKeyKeypadTypeNumberWithPasswordOnly maxLength:6 minLength:0];
    [pwTKField mTK_UseCursor:NO];
    [pwTKField mTK_UseAllDeleteButton:NO];
    [pwTKField mTK_SetInputEditboxImage:YES];
    [pwTKField mTK_SetHint:@"비밀번호" font: [UIFont systemFontOfSize:16]];

    [pwTKField mTK_UseVoiceOver:NO];

    [pwTKField mTK_textAlignCenter:NO];
    [pwTKField mTK_UseKeypadAnimation:YES];


    [pwTKField mTK_SetSizeOfInputPwKeyImage:12 height:15];
    [pwTKField mTK_SetSizeOfInputKeyImage:12 height:15];

    [pwTKField mTK_SetBottomSafeArea:YES];

    // 암호화 값 매번 같게 할지에 대한 설정
    [pwTKField mTK_EnableSamekeyInputDataEncrypt:NO];

    return self;
}


#pragma Out Interface Method
-(void)showKekypad
{
    NSLog(@"showKekypad");
    [pwTKField TranskeyBecomeFirstResponder];
    if(self.outputBaseView)
        self.outputBaseView.frame = CGRectMake(self.outputBaseView.frame.origin.x,
                                               _basePostionY - ([pwTKField mTK_GetCurrentKeypadHeight]/2),
                                   self.outputBaseView.frame.size.width, self.outputBaseView.frame.size.height);
}

-(void)hideKeypad
{
    NSLog(@"hideKekypad");
    [pwTKField TranskeyResignFirstResponder];
    if(self.outputBaseView )
        self.outputBaseView.frame = CGRectMake(self.outputBaseView.frame.origin.x,
                                               _basePostionY,
                                   self.outputBaseView.frame.size.width, self.outputBaseView.frame.size.height);



}

-(void)clear
{
    [pwTKField clear];
    [checkField clear];
    [_lockView setNumber:0];
}

-(void)initBaseView:(UIView*)view
{
    _basePostionY=view.frame.origin.y; //원 포지션값을 저장.
    self.outputBaseView=view;
}

/* TransKey    *****************/
#pragma mark - LockNumberViewDelegate
- (void)lockNumberKeypad {
//    self.alertLbl.text = @"";
    NSLog(@" %@ lockNumberKeypad",NSStringFromClass([self class]));
    [self showKekypad];
}

#pragma mark - TransKey Delegate

- (void)TransKeyDidBeginEditing:(TransKey *)transKey {
    strPassword = @"";
    checkField = transKey;
    [checkField mTK_UseCursor:NO];

}

- (void)TransKeyDidEndEditing:(TransKey *)transKey {

    [pwTKField TranskeyBecomeFirstResponder];
}

- (void)TransKeyInputKey:(NSInteger)keytype {
    
    [_lockView setNumber:checkField.length];

    if (checkField == pwTKField && checkField.length == 6) {
        [self CheckTransKey:checkField];
    }

}

- (void)CheckTransKey:(TransKey *)transKey {


//    numberChiperString = [transKey getCipherData];


    NSLog(@"numberChiperString : %@",numberChiperString);


    if (transKey == pwTKField){
        numberChiperString = [transKey getCipherDataExWithPadding];
    }
}

- (BOOL)TransKeyShouldReturn:(TransKey *)transKey {
//    NSLog(@"Return");



    if(pwTKField.length < 6){
        [self clear];
        [pwTKField TranskeyBecomeFirstResponder];

        RUN_ALERT_PANEL(@"비밀번호는 6자리입니다. 다시 입력해주세요");
        return NO;
    }
    else{
        NSString* pubKey = [[NSBundle mainBundle] pathForResource:@"Server2048" ofType:@"der"];
        strPassword = [pwTKField mTK_EncryptSecureKey:pubKey cipherString:numberChiperString];

        if([_secuKeypadDelegate respondsToSelector:@selector(secuKeypadReturn:)]){
            self.strNonCipherData=numberChiperString;
            [_secuKeypadDelegate secuKeypadReturn:strPassword];
        }
    }
    return YES;
}
/* TransKey    End *****************/


@end
