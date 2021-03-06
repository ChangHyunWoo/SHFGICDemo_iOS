//
//  MainViewController.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 1. 25..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewTopLayoutHeightConstraint;     ///< iPhone X Top 대응 HeightConstraint
@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewBottomLayoutHeightConstraint;  ///< iPhone X Bottom 대응 HeightConstraint

@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;
@property (nonatomic, retain) IBOutlet UIView *viewContents;


+ (void)updateProperty;

@end
