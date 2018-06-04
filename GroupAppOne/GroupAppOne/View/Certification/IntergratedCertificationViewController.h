//
//  IntergratedCertificationViewController.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 인증화면을 부르는 타입 또는 조건 */
typedef enum _IntCertCallType {
    CallTypeAuth = 1,       //인증
    CallTypeDisposal,       //해지
    CallTypePause           //정지
} IntCertCallType;

@interface IntergratedCertificationViewController : UIViewController

@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewTopLayoutHeightConstraint;     ///< iPhone X Top 대응 HeightConstraint
@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewBottomLayoutHeightConstraint;  ///< iPhone X Bottom 대응 HeightConstraint

@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBody;
@property (nonatomic, retain) IBOutlet UIView *viewContents;

@property (weak, nonatomic) IBOutlet UIView *viewKeyOutput;

- (void)callTypeSet:(IntCertCallType)type;
@end
