//
//  UIViewController+QRReqderViewcontroller.h
//  QRApp
//
//  Created by PYOINBEOM on 2015. 2. 7..
//  Copyright (c) 2015년 wapeul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TFBarcodeScanner.h"


//QR Scan CallBack
@protocol QRReaderDelegate <NSObject>

@optional
- (void)getQRCode:(NSString*)strQRCode;
@end

@interface QRReqderViewcontroller:TFBarcodeScannerViewController


@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewNavigationHeightConstraint; 


@property(nonatomic,retain)IBOutlet UILabel *mentLabel;
@property(nonatomic,retain)IBOutlet UIImageView *backView;
@property(nonatomic,retain)IBOutlet UIButton *onoffBtn;


@property(weak)id<QRReaderDelegate> qrReaderDelegate;
@end
