//
//  UIViewController+QRReqderViewcontroller.m
//  QRApp
//
//  Created by PYOINBEOM on 2015. 2. 7..
//  Copyright (c) 2015년 wapeul. All rights reserved.
//

#import "QRReqderViewcontroller.h"

@implementation QRReqderViewcontroller

@synthesize mentLabel = _mentLabel;
@synthesize backView = _backView;
@synthesize onoffBtn = _onoffBtn;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"신한통합인증 PC 인증";
    [MainNavigationController setNavigationBackButton:self.navigationController setItems:self.navigationItem setDelegate:self isBack:YES isRightMenu:YES];
    
    self.barcodeTypes = TFBarcodeTypeEAN8 | TFBarcodeTypeEAN13 | TFBarcodeTypeUPCA | TFBarcodeTypeUPCE | TFBarcodeTypeQRCODE;
    //[self setSubViews];
    
    [self.mentLabel setText:[NSString stringWithFormat:@"신한금융그룹사 PC 화면의 QR을\n아래 영역에 인식시켜 주세요."]];
    
    
    if (IOS_VERSION_GREATER_THAN(11) && IS_IPHONE_X)
    {
        /***** TopLayout / BottomLayou GuideViewHeight *****/
        //[_viewNavigationHeightConstraint setConstant:self.navigationController.toolbar.frame.size.height + self.topLayoutGuide.length];
        [_viewNavigationHeightConstraint setConstant:88.0f];
    }
    else
    {
        [_viewNavigationHeightConstraint setConstant:self.navigationController.toolbar.frame.size.height + 20.f];
    }
    
    [D_CA hideLoading];
}

-(void)setSubViews
{
    CGRect viewFrame = [[UIScreen mainScreen] applicationFrame];
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, viewFrame.size.width, viewFrame.size.height+40)];
    [qrImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, viewFrame.size.width, viewFrame.size.height+40)];
    
    [self.backView setContentMode:UIViewContentModeScaleAspectFit];
    [self.backView setAlpha:0.0f];
    
    if ( [[UIScreen mainScreen] applicationFrame].size.height >= 548 ) {
//        [qrImageView setImage:[UIImage imageNamed:@"qr_overlay.png"]];
//        [self.backView setImage:[UIImage imageNamed:@"qr_overlay_on.png"]];
    }else{
//        [qrImageView setImage:[UIImage imageNamed:@"qr_overlay35.png"]];
//        [self.backView setImage:[UIImage imageNamed:@"qr_overlay35_on.png"]];
    }

    [self.view addSubview:qrImageView];
    qrImageView.layer.zPosition = 0;
//    배경 이미지 뎁스 조정
    for(int i = 0 ; i<= self.view.subviews.count-1 ; i++)
    {
        [[[self.view.subviews objectAtIndex:i] layer] setZPosition:i+1];
    }
    [[[self.view.subviews objectAtIndex:self.view.subviews.count-1] layer] setZPosition:0];
    
//    [self.onoffBtn setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
//    [self.onoffBtn setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateSelected];
//
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TFBarcodeScannerViewController

- (void)barcodePreviewWillShowWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{

    } completion:^(BOOL finished) {

    }];
}

- (void)barcodePreviewWillHideWithDuration:(CGFloat)duration
{
    
}

#pragma Result View
- (void)barcodeWasScanned:(NSSet *)barcodes
{
    [self stop];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    TFBarcode* barcode = [barcodes anyObject];

//    [D_UD setValue:barcode.string forKey:D_UD_QRCODEDATA];
    
    [self dismissModalViewControllerAnimated:YES];
    
    
//    NSLog(@"%@",barcode.string);
    [UIView animateWithDuration:0.2 animations:^{
        [_qrReaderDelegate getQRCode:barcode.string];
    }];
}

#pragma mark - Private

- (NSString *)stringFromBarcodeType:(TFBarcodeType)barcodeType
{
    static NSDictionary *typeMap;
    
    if (!typeMap) {
        typeMap = @{
                    @(TFBarcodeTypeEAN8):         @"EAN8",
                    @(TFBarcodeTypeEAN13):        @"EAN13",
                    @(TFBarcodeTypeUPCA):         @"UPCA",
                    @(TFBarcodeTypeUPCE):         @"UPCE",
                    @(TFBarcodeTypeQRCODE):       @"QRCODE",
                    @(TFBarcodeTypeCODE128):      @"CODE128",
                    @(TFBarcodeTypeCODE39):       @"CODE39",
                    @(TFBarcodeTypeCODE39Mod43):  @"CODE39Mod43",
                    @(TFBarcodeTypeCODE93):       @"CODE93",
                    @(TFBarcodeTypePDF417):       @"PDF417",
                    @(TFBarcodeTypeAztec):        @"Aztec"
                    };
    }
    
    return typeMap[@(barcodeType)];
}


- (IBAction)handleButtonFloshOnOff:(UIButton *)button;
{
    button.selected = !button.selected;
    [self setTorch:button.selected];
    
    
}

- (IBAction)handleButtonClose:(UIButton *)button;
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setTorch:(BOOL)status {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( status ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
        
    }
}

@end
