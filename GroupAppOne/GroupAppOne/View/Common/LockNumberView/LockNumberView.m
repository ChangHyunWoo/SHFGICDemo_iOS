//
//  LockNumberView.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "LockNumberView.h"

@implementation LockNumberView


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {

        UIView *view = nil;
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LockNumberView"
                                                         owner:self
                                                       options:nil];
        for (id object in objects) {
            if ([object isKindOfClass:[UIView class]]) {
                view = object;
                break;
            }
        }

        view.translatesAutoresizingMaskIntoConstraints = YES ;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;

        [self addSubview:view];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *view = nil;
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LockNumberView"
                                                         owner:self
                                                       options:nil];
        for (id object in objects) {
            if ([object isKindOfClass:[UIView class]]) {
                view = object;
                break;
            }
        }
        view.frame= frame;
        [view setNeedsLayout] ;
        [view layoutIfNeeded] ;
        view.translatesAutoresizingMaskIntoConstraints=YES;
        view.autoresizesSubviews=YES;

        [self addSubview:view];
    }

    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

+ (id)loadNibFromClass:(Class)tmpClass withNibName:(NSString *)nibNmae {
    NSArray *loadedNib = [[NSBundle mainBundle] loadNibNamed:nibNmae owner:self options:nil];
    
    for (id obj in loadedNib) {
        if ([obj isKindOfClass:tmpClass]) {
            return obj;
        }
    }
    
    return [[tmpClass alloc] init];
}



- (void)setNumber:(NSInteger)number {

    switch (number) {
        case 0:
            [_btNum1 setSelected:NO];
            [_btNum2 setSelected:NO];
            [_btNum3 setSelected:NO];
            [_btNum4 setSelected:NO];
            [_btNum5 setSelected:NO];
            [_btNum6 setSelected:NO];
            break;
        case 1:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:NO];
            [_btNum3 setSelected:NO];
            [_btNum4 setSelected:NO];
            [_btNum5 setSelected:NO];
            [_btNum6 setSelected:NO];
            break;
        case 2:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:YES];
            [_btNum3 setSelected:NO];
            [_btNum4 setSelected:NO];
            [_btNum5 setSelected:NO];
            [_btNum6 setSelected:NO];
            break;
        case 3:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:YES];
            [_btNum3 setSelected:YES];
            [_btNum4 setSelected:NO];
            [_btNum5 setSelected:NO];
            [_btNum6 setSelected:NO];
            break;
        case 4:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:YES];
            [_btNum3 setSelected:YES];
            [_btNum4 setSelected:YES];
            [_btNum5 setSelected:NO];
            [_btNum6 setSelected:NO];
            break;
        case 5:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:YES];
            [_btNum3 setSelected:YES];
            [_btNum4 setSelected:YES];
            [_btNum5 setSelected:YES];
            [_btNum6 setSelected:NO];
            break;
        case 6:
            [_btNum1 setSelected:YES];
            [_btNum2 setSelected:YES];
            [_btNum3 setSelected:YES];
            [_btNum4 setSelected:YES];
            [_btNum5 setSelected:YES];
            [_btNum6 setSelected:YES];
            break;
        default:
            break;
    }

}

-(void)setDelegate:(id<LockNumberViewDelegate>)delegate
{
    _delegate=delegate;
}

- (IBAction)actionKeypad:(id)sender {
    if ([_delegate respondsToSelector:@selector(lockNumberKeypad)]) {
        [_delegate lockNumberKeypad];
    }
}

@end
