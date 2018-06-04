//
//  PasswordViewController.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockNumberView.h"


// =========== ViewType Define
#define PASSWORDVIEWTYPE_RESET @"PaswwordReset" // 비밀번호 재 설정
#define PASSWORDVIEWTYPE_DISPOSALL @"PasswordDisposall" // 서비스 해지
#define PASSWORDVIEWTYPE_CONFIRM @"PasswordConfirm" // 기존 가입자 (타그룹사에서 가입 등) 에서 기존 핀번호 확인 시
#define PASSWORDVIEWTYPE_ADDFINGER @"AddFinger" // 추가 등록 (지문인증)
#define PASSWORDVIEWTYPE_CHANGEADDFINGER @"ChangeAddFinger" // 지문변경 시 추가 등록 (지문인증)
#define PASSWORDVIEWTYPE_QRAUTH @"QRAuth" // QR 핀인증 시

@interface PasswordViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;
@property (nonatomic, retain) IBOutlet UIView *viewContents;
@property (weak, nonatomic) IBOutlet UIView *viewKeyOutput;

//비밀번호 체크 진입 Type Flag
@property (nonatomic, strong) NSString *viewType;
//비밀번호 재 설정 시 인증 실행 여부 ( 비밀번호 재설정 인증 단계 완료후 & 초기화 YES)
@property (nonatomic,assign) BOOL isDoReset;

@end
