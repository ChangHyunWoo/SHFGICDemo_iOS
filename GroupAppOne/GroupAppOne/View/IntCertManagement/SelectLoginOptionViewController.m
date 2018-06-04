//
//  SelectLoginOptionViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>

#import "SelectLoginOptionViewController.h"
#import "PasswordViewController.h"
#import <public_onepass/OnePassUtil.h>
#import <public_onepass/OnePassErrorCode.h>

@interface SelectLoginOptionViewController ()<FidoTransactionDelegate>
{
    NSString *oldType ;
}
@property (weak, nonatomic) IBOutlet UIButton *passwordBtnBack;
@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;
@property (weak, nonatomic) IBOutlet UIButton *fidoBtnBack;
@property (weak, nonatomic) IBOutlet UIButton *fidoBtn;

@property(nonatomic, retain) IBOutlet UIButton* cancelBtn;
@property(nonatomic, retain) IBOutlet UIButton* confirmBtn;

@end

@implementation SelectLoginOptionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"신한통합인증 로그인 설정";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];

    [D_CA setButtonBorder:_cancelBtn setBorderColor:@"#161c34"];
    [D_CA setButtonBorder:_confirmBtn setBorderColor:@""];


    // 지문 사용가능 여부 체크
    BOOL available = [D_CA isTouchValiable]; //[OnePassUtil touchidAvailableState];
    if(available)// 사용가능
    {
        [_fidoBtnBack setEnabled:YES];
        [_fidoBtn setEnabled:YES];
    }
    else{
        [_fidoBtnBack setEnabled:NO];
        [_fidoBtn setEnabled:NO];
    }

    //기존 설정 정보 가져오기.
    NSMutableDictionary *tempDict = [UserInfo getUserInfo];
    oldType=[tempDict objectForKey:KEY_LOGIN_TYPE];

    if(tempDict){
        if([[tempDict objectForKey:KEY_LOGIN_TYPE] isEqualToString:@"00"]){
            [_passwordBtn setSelected:YES];
            [_fidoBtn setSelected:NO];
        }
        else{
            [_passwordBtn setSelected:NO];
            [_fidoBtn setSelected:YES];
        }
    }
    else{//기존 정보가 없다면 PIN Default
        [_passwordBtn setSelected:YES];
        [_fidoBtn setSelected:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)passwordTouchUpInside:(id)sender
{
    if(!_passwordBtn.isSelected){
        [_fidoBtn setSelected:NO];
        [_passwordBtn setSelected:YES];
    }
}

- (IBAction)fidoTouchUpInside:(id)sender
{
    NSMutableDictionary *dicUserInfo = [UserInfo getUserInfo];

    // 기존 지문인증 등록이 되어 있는경우. (LocalPreference)
    if([[dicUserInfo objectForKey:KEY_ISREGISTFIDO] isEqualToString:@"01"]){
        if(!_fidoBtn.isSelected){
            [_fidoBtn setSelected:YES];
            [_passwordBtn setSelected:NO];
        }
    }
    // 기존 지문인증 등록이 되어 있지 않은 경우 = 등록절차 진행  (LocalPreference)
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"OnePass"
                                      message:@"신한통합인증 지문이 등록되어 \n 있지 않습니다. \n 신한통합인증 로그인을 지문으로 설정 하시겠습니까?"
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];

        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"확인"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                                 [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistAuth forKey:@"REQUEST_TYPE"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];

                                 PasswordViewController* passwordView = [[PasswordViewController alloc] init];
                                 passwordView.viewType=PASSWORDVIEWTYPE_ADDFINGER;
                                 [self.navigationController pushViewController:passwordView animated:YES];

                             }];

        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)cancelTouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmTouchUpInside:(id)sender
{
    NSString* isFidoLogin;
    if(_passwordBtn.isSelected){
        isFidoLogin=@"00";
    }
    else{
        isFidoLogin=@"01";
    }

    //변경되지 않았을때 처리하지 않음.
    if([oldType isEqualToString:isFidoLogin]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self setLoginType:isFidoLogin];
}


-(void)setLoginType:(NSString*)isFidoLogin
{
    NSMutableDictionary* intCertDict = [[UserInfo getUserInfo] mutableCopy];
    [intCertDict setObject:isFidoLogin forKey:KEY_LOGIN_TYPE];
    [intCertDict setObject:[[SHICUser defaultUser] get:KEY_ICID] forKey:KEY_ICID];

    [[SHICUser defaultUser] put:isFidoLogin value:KEY_LOGIN_TYPE];
    [UserInfo saveUesrInfo:intCertDict];

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"OnePass"
                                  message:@"신한통합인증 로그인 설정이 \n  변경되었습니다. \n 변경하신 로그인 수단으로 다시 로그인해 주세요."
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"확인"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //To-do : 로그아웃 처리.
                             [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];

                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popToRootViewControllerAnimated:YES];
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
                             [[NSUserDefaults standardUserDefaults] synchronize];

                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
