//
//  AppDelegate.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 1. 25..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//========== QR Read 화면에서 불러온 데이터 Network Class전달용 변수.
@property (strong, nonatomic) NSString* sendQRData;
//========== Pasword Check 변수 저장
@property (strong, nonatomic) NSString* checkPassword1;
@property (strong, nonatomic) NSString* checkPassword2;

@end

