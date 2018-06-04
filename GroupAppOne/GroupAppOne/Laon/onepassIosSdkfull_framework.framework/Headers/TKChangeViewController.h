//
//  TKChangeViewController.h
//  onepassIosSdkfull
//
//  Created by raon on 2016. 4. 29..
//  Copyright © 2016년 h. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "SettingProto.h"

#import "TransKey.h"
#import "TransKeyView.h"

@interface TKChangeViewController: UIViewController <TransKeyDelegate>
//@interface TKChangeViewController: UIViewController

//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (strong, nonatomic) IBOutlet UIButton *resetBtn;
//@property (strong, nonatomic) IBOutlet UIButton *okBtn;
//@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pinTopLineView;
@property (weak, nonatomic) IBOutlet UIImageView *pinBottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *labelGuide;

@property (weak, nonatomic) IBOutlet UICollectionView *pinNumCollectionView;

@property (strong, nonatomic) NSMutableArray* collectionViewCellArray;

@property (strong, nonatomic) id m_delegate;
@property (strong, nonatomic) NSString* m_caller;

//- (IBAction)complete:(id)sender;
//- (IBAction)reset:(id)sender;
//- (IBAction)cancel:(id)sender;

//- (void) initTKSetViewController:(id)delegate Caller:(NSString *)caller;

- (void)setKeyId:(NSString*)keyIdBase64;
- (void)setAuthenticatorIndex:(int)authenticatorType;

- (void)showLog;

@end
