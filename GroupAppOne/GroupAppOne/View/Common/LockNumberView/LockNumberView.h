//
//  LockNumberView.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIView+Xib.h"

@protocol LockNumberViewDelegate;

@interface LockNumberView : UIView

@property (assign, nonatomic) id<LockNumberViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *btNum1;
@property (strong, nonatomic) IBOutlet UIButton *btNum2;
@property (strong, nonatomic) IBOutlet UIButton *btNum3;
@property (strong, nonatomic) IBOutlet UIButton *btNum4;
@property (strong, nonatomic) IBOutlet UIButton *btNum5;
@property (strong, nonatomic) IBOutlet UIButton *btNum6;

- (IBAction)actionKeypad:(id)sender;

- (void)setNumber:(NSInteger)number;

@end

@protocol LockNumberViewDelegate <NSObject>

- (void)lockNumberKeypad;

@end
