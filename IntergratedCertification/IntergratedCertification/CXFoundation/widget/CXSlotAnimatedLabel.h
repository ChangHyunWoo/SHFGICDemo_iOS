//
//  CXSlotAnimatedLabel.h
//  CXFoundation
//
//  Created by Kalce on 2017. 12. 26..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXSlotAnimatedLabel : UIView

@property(nonatomic)                            BOOL            adjustWidthTextSize;
@property(nonatomic)                            NSTimeInterval  duration;
@property(nullable, nonatomic, copy)            NSString*       text;
@property(null_resettable, nonatomic, strong)   UIFont*         font;
@property(null_resettable, nonatomic, strong)   UIColor*        textColor;

- (void)setText:(NSString*)text animated:(BOOL)animated;
- (void)startAnimation;
- (void)stopAnimation;

@end
