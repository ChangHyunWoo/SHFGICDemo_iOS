//
//  InformationUseViewController.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//
#import <IntergratedCertification/IntergratedCertification.h>
#import <public_onepass/OnePassUtil.h>
#import <public_onepass/OnePassErrorCode.h>

#import "InformationUseViewController.h"
#import "AuthorizationViewController.h"
#import "AddAuthorizationViewController.h"

@interface InformationUseViewController ()<FidoTransactionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;

@end

@implementation InformationUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"신한통합인증 이용안내";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];
    [D_CA createWebview:self.viewContents setUrl:WEBURL_SERVICETERM];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 신한통합인증 해지 버튼 액션
- (IBAction)joinTouchUpInside:(id)sender{
    //To-do
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    
    [transaction requestFido:FidoCommandForAllowedDevice];
    
}
#pragma  - FidoTransaction Delegate
- (void)fidoResult:(FidoTransaction*)fidoTransaction{
    FidoTransaction* tr =fidoTransaction;
    if(tr.isOK){
        NSMutableArray* aaidList = [NSMutableArray arrayWithCapacity:0];
        NSArray* aaidArray = tr.rtnResultData[@"aaidAllowList"];

        for(NSDictionary* dict in aaidArray){
            [aaidList addObject:dict[@"aaid"]];
            
        }
        
        // 원패스 라이브러리 사용 가능 여부.(OS버전 ,AAID 리스트 체크. )
        NSInteger available = [OnePassUtil checkDeviceAvailable:aaidList];
        NSString *resultCode = @"00";

        // 사용 가능
        if(available == 0)
        {
            //
        }
        else if(available == ERROR_FAIL_FIND_DEVICE_TYPE || available == ERROR_NOT_SET_PASSCODE ||
                available == ERROR_FAIL_UNSUPPORT_LOW_VER || available == ERROR_TOUCHID_NOT_ENROLLED ||available == ERROR_NOT_SET_PASSCODE )
        {
            resultCode = @"휴대폰에 등록된 지문 정보가 없습니다\n설정>Touch ID 및 암호에서 등록";
        }
        // 사용가능한 aaid 목록이 발견되지 않았습니다. 관리자에게 문의 하시길 바랍니다.
        else if(available == ERROR_FAIL_FIND_AAID)
        {
            resultCode = @"등록에 실패하였습니다.\n고객센터 1599-8000에 문의하시길 바랍니다"; //은행
        }
        // 지문 인증을 사용할수가 없습니다.
        else if(available == ERROR_TOUCHID_TRYOVER_OS){
            resultCode = @"지문인증에 실패하였습니다.\n지문영역을 터치하여 다시 활성화 해주세요.\n설정 > TOUCH ID > iPhone 잠금해제";
        }
        else
        {
            resultCode = @"등록에 실패하였습니다.\n고객센터 1599-8000에 문의하시길 바랍니다"; //은행
        }
        
        // 지문 사용 가능 여부 체크.
        if ([resultCode isEqualToString:@"00"])
        {
            available = [OnePassUtil touchidAvailableState];
            
            // 사용가능
            if(available == 0)
            {
                [self moveNext];
                return;
                
            }
            else if(available == ERROR_FAIL_FIND_DEVICE_TYPE || available == ERROR_NOT_SET_PASSCODE || available == ERROR_TOUCHID_NOT_ENROLLED)
            {
                resultCode = @"휴대폰에 등록된 지문 정보가 없습니다\n설정>Touch ID 및 암호에서 등록";
            }
            else
            {
                resultCode = @"등록에 실패하였습니다.\n고객센터 1599-8000에 문의하시길 바랍니다";
            }
        }
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:resultCode
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:tr.rtnMsg
                                                         delegate:nil
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

-(void) moveNext{
    //각 그룹사의 본인인증 수단의 화면을 호출한다.
    NSString* joinUser =[[SHICUser defaultUser] getString:KEY_NAME];
    if([joinUser length] > 0 ){
        BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN_OTHER];
        if(isLogin) {
            AddAuthorizationViewController* addAuthViewController = [[AddAuthorizationViewController alloc] init];
            [self.navigationController pushViewController:addAuthViewController animated:YES];
            
        }
        else{
            AuthorizationViewController* authViewController = [[AuthorizationViewController alloc] init];
            [self.navigationController pushViewController:authViewController animated:YES];
            
        }
    }
    else{
        AuthorizationViewController* authViewController = [[AuthorizationViewController alloc] init];
        [self.navigationController pushViewController:authViewController animated:YES];
    }

}

@end
