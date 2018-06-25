//
//  IntCertManagementViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "IntCertManagementViewController.h"
#import "IntCertManagementTableViewCell.h"
#import "SelectLoginOptionViewController.h"
#import "DisposalSelectViewController.h"
#import "PasswordViewController.h"
#import "DisposalInfomationViewController.h"
#import "InformationUseViewController.h"

#import <IntergratedCertification/IntergratedCertification.h>
#import "IntergratedCertificationViewController.h"
#import "QRReqderViewcontroller.h"

#import "PasswordViewController.h"
#import "FingerPrintViewController.h"


@interface IntCertManagementViewController ()<QRReaderDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) NSMutableArray*       tableViewElements;
@property (strong, nonatomic) IBOutlet UITableView*          tableView;
@end

@implementation IntCertManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"신한 올패스센터";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:NO];
    self.tableViewElements = [NSMutableArray arrayWithObjects: @"신한 올패스 가입/등록", @"신한 올패스 해지/정지", @"신한 올패스 비밀번호 재설정", @"신한 올패스 로그인 설정",@"QR Test", nil];

    _tableHeight.constant = self.tableViewElements.count * self.tableView.rowHeight;
    [self.tableView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //신한 통합인증 가입/등록
    if(indexPath.row == 0){
        InformationUseViewController* infoUseViewController = [[InformationUseViewController alloc] init];
        [self.navigationController pushViewController:infoUseViewController animated:YES];
    }
    //신한 통합인증 해지/정지
    else if(indexPath.row == 1){
        DisposalSelectViewController * selectView = [[DisposalSelectViewController alloc] init];
        [self.navigationController pushViewController:selectView animated:YES];
    }
    //신한 통합인증 비밀번호 재설정
    else if(indexPath.row == 2){

        // 미 로그인 진입 불가
        if(![[SHICUser defaultUser] getBoolean:KEY_LOGIN]){

            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:@"통합인증 비밀번호를 재설장하시려면 통합인증으로 로그인 해주시기 바랍니다."
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

                                     //로그인화면으로
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                 }];

            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        else{
            [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForPasswordChangeAuth forKey:@"REQUEST_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            PasswordViewController *resetView = [[PasswordViewController alloc] init];
            resetView.viewType= PASSWORDVIEWTYPE_RESET;
            [self.navigationController pushViewController:resetView animated:YES];
        }
    }
    //신한 올패스 로그인 설정
    else if(indexPath.row == 3){
        // 미 로그인 진입 불가
        if(![[SHICUser defaultUser] getBoolean:KEY_LOGIN]){
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:@"통합인증 로그인 설정을 변경하시려면 통합인증으로 로그인 해주시기 바랍니다."
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
                                     
                                     //로그인화면으로
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INT_CERT_LOGIN"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                 }];
            
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        SelectLoginOptionViewController *selectLogin = [[SelectLoginOptionViewController alloc] init];
        [self.navigationController pushViewController:selectLogin animated:YES];
    }
    else if(indexPath.row == 4){
        if([UserInfo getUserInfo]){
            CertificateManager *certManager = [[CertificateManager alloc] initWithDelegate:self];
            certManager.commendType=CertificateManageCommandTypeAuth;
            certManager.verifyType=SERVERCODE_VERIFYTYPE_PIN;
            [certManager requestVerify:FidoVerifyAuth];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewElements count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if( tableView == self.tableView ) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IntCertManagementTableViewCell" owner:self options:nil];
            cell =  [nib objectAtIndex:0];
        }
    }
    //NSDictionary* row = self.tableViewElements[indexPath.row];
    

    IntCertManagementTableViewCell* menuCell = (IntCertManagementTableViewCell*)cell;
    
    menuCell.titleLbl.text = self.tableViewElements[indexPath.row];

    menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return menuCell;
}

#pragma Verify Delegate
- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)dataBody{

    if(isOK){
        NSString* stateCode = dataBody[@"icData"][@"stateCode"];
        if(stateCode !=nil && [stateCode isEqualToString:SERVERCODE_STATECODE_SUC]){
            //================ 모두 정상.
            if([CertificateManager checkicDataAuth:dataBody[@"icData"]]){
                if([UserInfo getUserInfo]){
                    QRReqderViewcontroller *controller = [[QRReqderViewcontroller alloc] init];
                    controller.qrReaderDelegate=self;
                    //[self presentViewController:controller animated:YES completion:^{}];
                     [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
        else{
            RUN_ALERT_PANEL(@"등록된 인증서가 해지 되었거나 삭제되었습니다.");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else {
        RUN_ALERT_PANEL(msg);
    }
}

#pragma QR Delegate
- (void)getQRCode:(NSString*)strQRCode
{
    NSString *strReadQR=[NSString stringWithFormat:@"%@",strQRCode];

    //보낼 QR 데이터 저장.
    D_CD.sendQRData = strReadQR;


    [self popupSelectLogion:@"QR 스캔이 완료되었습니다."];
//    [self popupSelectLogion:@"QR 스캔이 완료되었습니다. 신한 올패스 PC 인증을 위한 비밀번호 또는 지문 인증 방식을 선택해 주세요."];

//    IntergratedCertificationViewController* intCertViewController = [[IntergratedCertificationViewController alloc] init];
//    [intCertViewController callTypeSet:CallTypeQRAuth];
//    [self.navigationController pushViewController:intCertViewController animated:YES];

}

-(void)popupSelectLogion:(NSString*)msg
{
    NSMutableDictionary *userInfo= [UserInfo getUserInfo];
    //================ 가입정보 확인
    if(!userInfo){
        //에러처리
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    //========== Request Set.
    [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserQRAuth forKey:@"REQUEST_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //================ 기존 지문이 등록되지 않은 경우.
    if(![[userInfo objectForKey:KEY_ISREGISTFIDO] isEqualToString:@"01"]){
        PasswordViewController* passwordView = [[PasswordViewController alloc] init];
        passwordView.viewType=PASSWORDVIEWTYPE_QRAUTH;
        [self.navigationController pushViewController:passwordView animated:YES];
        return;
    }

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"알림"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];

//    UIAlertAction* cancel = [UIAlertAction
//                             actionWithTitle:@"비밀번호 확인"
//                             style:UIAlertActionStyleDefault
//                             handler:^(UIAlertAction * action){
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                 PasswordViewController* passwordView = [[PasswordViewController alloc] init];
//                                 passwordView.viewType=PASSWORDVIEWTYPE_QRAUTH;
//                                 [self.navigationController pushViewController:passwordView animated:YES];
//                             }];

    UIAlertAction* ok = [UIAlertAction
//                         actionWithTitle:@"지문 인증"
                         actionWithTitle:@"확인"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];

                             //============= 로그인 설정에 따른 인증화면으로 이동.
                             if([[userInfo objectForKey:KEY_LOGIN_TYPE] isEqualToString:@"01"]){
                                 FingerPrintViewController* fingerViewConroller = [[FingerPrintViewController alloc] init];
                                 fingerViewConroller.viewType=FINGERPRINTVIEW_FingerQRAuth;
                                 [self.navigationController pushViewController:fingerViewConroller animated:YES];
                             }
                             else{
                                 PasswordViewController* passwordView = [[PasswordViewController alloc] init];
                                 passwordView.viewType=PASSWORDVIEWTYPE_QRAUTH;
                                 [self.navigationController pushViewController:passwordView animated:YES];

                             }
                         }];

//    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
