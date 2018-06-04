//
//  FingerPrintViewController.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FINGERPRINTVIEW_FingerRegist @"FingerRegist" //인증수단 추가 등록 (가입 후 추가)
#define FINGERPRINTVIEW_FingerChange @"FingerChange" //인증수단 추가 등록 (지문변경시 추가)
#define FINGERPRINTVIEW_FingerQRAuth @"QRAuth" //QR인증

@interface FingerPrintViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;
@property (nonatomic, retain) IBOutlet UIView *viewContents;

@property (nonatomic, strong) NSString *viewType;

@end
