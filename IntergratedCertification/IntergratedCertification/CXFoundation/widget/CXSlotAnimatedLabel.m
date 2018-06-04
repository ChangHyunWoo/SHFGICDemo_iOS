//
//  CXSlotAnimatedLabel.m
//  CXFoundation
//
//  Created by Kalce on 2017. 12. 26..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXSlotAnimatedLabel.h"

@interface CXSlotAnimatedLabel () {
    NSMutableArray<NSMutableDictionary*>*   _words;
    id                                      _displayLink;
    NSTimeInterval                          _timestamp;
}

@end

@implementation CXSlotAnimatedLabel

double easeInOutQuad(double t) { return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t; }
double easeInOutCubic(double t) { return t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1; }
//double easeInOutQuint(double t) { return t < 0.5 ? 16.0 * t * t * t * t * t : 1.0 + 16.0 * (--t) * t * t * t * t; }

- (id)init {
    self = [super init];
    if( self ) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if( self ) {
        [self initialize];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    [self setText:text animated:NO];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    if( _font == nil )
        _font = [UIFont systemFontOfSize:16];
    
    [self updateWidthAnimated:NO];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if( _textColor == nil )
        _textColor = [UIColor blackColor];
    
    [self setNeedsDisplay];
}

- (void)initialize {
    _duration               = 2.0;
    _adjustWidthTextSize    = YES;
    _words                  = [[NSMutableArray alloc] init];
    _font                   = [UIFont systemFontOfSize:16];
    _textColor              = [UIColor blackColor];
}

- (void)setText:(NSString*)text animated:(BOOL)animated {
    _text = text;
    
    [_words removeAllObjects];
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    for (int i = 0; i < [_text length]; i++) {
        NSString *character  = [_text substringWithRange:NSMakeRange(i, 1)];
        NSMutableDictionary* word = [[NSMutableDictionary alloc] init];
        NSNumber* number = [numberFormatter numberFromString:character];
        
        word[@"CHARACTER"]  = character;
        if( number != nil ) {
            NSMutableArray* slots = [[NSMutableArray alloc] init];
            for(int j = 0; j <= [character intValue]; j++ )
                [slots addObject:[NSString stringWithFormat:@"%d", j]];
            
            word[@"SLOTS"]      = slots;
            word[@"CURRENT"]    = @"0";
        } else {
            word[@"CURRENT"]    = character;
        }
        
        
        [_words addObject:word];
    }
    
    [self updateWidthAnimated:animated];
    [self setNeedsDisplay];
    
    if( animated ) {
        [self startAnimation];
    }
}

- (void)startAnimation {
    _timestamp = CACurrentMediaTime();
    for( int i = 0; i < [_words count]; i++ ) {
        if( _words[i][@"SLOTS"] == nil ) continue;
        
        _words[i][@"VALUE"]     = @(0);
    }
    
    _displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(loop)];
    [_displayLink setPreferredFramesPerSecond:60];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAnimation {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)loop {
    NSTimeInterval accumulate   = ( CACurrentMediaTime() - _timestamp );
    NSTimeInterval time         = accumulate / _duration;
    
    if(time >= 1.0f) {
        time = 1.0f;
        
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    for( int i = 0; i < [_words count]; i++ ) {
        NSArray* slots = _words[i][@"SLOTS"];
        if( slots == nil || [slots count] <= 1 ) continue;
        
        _words[i][@"VALUE"]     = @(([slots count] - 1) * easeInOutCubic(time));
    }

    [self setNeedsDisplay];
}

- (void)updateWidthAnimated:(BOOL)animated {
    if( _adjustWidthTextSize ) {
        NSDictionary* textFontAttributes = [self textFontAttributes];
        CGFloat accumlate  = 0.0f;
        
        for( int i = 0; i < [_words count]; i++ ) {
            NSString* word = _words[i][@"CHARACTER"];
            CGSize wordSize = [word sizeWithAttributes:textFontAttributes];
            accumlate += wordSize.width;
        }
        
        if( self.translatesAutoresizingMaskIntoConstraints ) {
            if( animated ) {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ceilf(accumlate), self.frame.size.height);
                                 }
                                 completion:^(BOOL finished){
                                 }];
            } else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ceilf(accumlate), self.frame.size.height);
            }
        } else {
            NSLayoutConstraint* constraint = nil;
            for(NSLayoutConstraint* inner in self.constraints) {
                if(inner.firstAttribute == NSLayoutAttributeWidth) {
                    constraint = inner;
                    break;
                }
            }
            
            constraint.constant = ceilf(accumlate);

//            if( animated ) {
//                [UIView animateWithDuration:0.5
//                                      delay:0.0
//                                    options: UIViewAnimationOptionCurveEaseOut
//                                 animations:^{
//                                     constraint.constant = ceilf(accumlate);;
//                                     [self layoutIfNeeded];
//}
//                                 completion:^(BOOL finished){
//                                 }];
//            } else {
//                constraint.constant = ceilf(accumlate);
//                [self layoutIfNeeded];
//            }
        }
    }
}

- (NSDictionary*)textFontAttributes {
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    return @{NSFontAttributeName: _font, NSForegroundColorAttributeName: _textColor, NSParagraphStyleAttributeName: textStyle};
}

- (void)drawRect:(CGRect)rect {
    NSDictionary* textFontAttributes = [self textFontAttributes];
    
    CGSize  size        = [_text sizeWithAttributes:textFontAttributes];
    CGFloat offset      = (NSInteger)((rect.size.height * 0.5f) - (size.height * 0.5f));
    CGFloat accumlateX  = 0.0f;
    CGFloat accumlateY  = 0.0f;
    
    CGContextRef    context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, offset, rect.size.width, size.height));
    CGContextClip(context);
    for( int i = 0; i < [_words count]; i++ ) {
        NSString* word = _words[i][@"CHARACTER"];
        CGSize wordSize = [word sizeWithAttributes:textFontAttributes];
    
        if( _words[i][@"SLOTS"] == nil ) {
            [word drawAtPoint:CGPointMake(accumlateX, offset) withAttributes:textFontAttributes];
        }else {
            CGFloat y = size.height * [_words[i][@"VALUE"] floatValue];
            accumlateY = 0;
            NSArray* slots = _words[i][@"SLOTS"];
            for( int j = 0; j < [slots count]; j++ ) {
                CGSize  itemSize = [slots[j] sizeWithAttributes:textFontAttributes];
                [slots[j] drawAtPoint:CGPointMake(accumlateX, offset - accumlateY + y) withAttributes:textFontAttributes];
                accumlateY += itemSize.height;
            }
        }
        accumlateX += wordSize.width;
    }
}

@end
