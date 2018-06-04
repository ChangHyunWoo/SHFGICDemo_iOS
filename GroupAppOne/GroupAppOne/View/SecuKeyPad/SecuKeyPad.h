//
//  NSObject+SecuKeyPad.h
//  GroupAppOne
//
//  Created by INBEOM on 2018. 3. 2..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransKey.h"
#import "TransKeyView.h"
#import "LockNumberView.h"
#import "AppDelegate.h"



@protocol SecuKeypadDelegate<NSObject>

@required
-(void)secuKeypadReturn:(NSString*)strInputKey;

@end



@interface SecuKeyPad:NSObject

@property (nonatomic, assign) id<SecuKeypadDelegate> secuKeypadDelegate;
@property (nonatomic, strong) NSString* strNonCipherData; // 공개키 암호화 되지 않은 데이터
@property (nonatomic, strong) UIView * outputBaseView;// 키패드가 보여지는 화면. (팝업시 Size조정을 위해 상속받음)

-(SecuKeyPad*)initView:(UIView*)outputView;
-(void)initBaseView:(UIView*)view;
-(void)showKekypad;
-(void)hideKeypad;
-(void)clear;

@end
