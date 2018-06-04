/*==============================================================================
 - TransKey.h (컨트롤 분리 secureKeyboard)
 ==============================================================================*/

#import <Foundation/Foundation.h>

@class TransWebKey;

enum {
    NormalKey,
    DeleteKey,
    ClearallKey
};

enum{
    CancelCmdType,
    CompleteCmdType,
    NaviCancelCmdType,
    NaviCompleteCmdType,
    NaviBeforeCmdType,
    NaviNextCmdType,
};

/*==============================================================================
 secureKeyboard(컨트롤분리) keypad type
 ==============================================================================*/
enum {
    TransKeyKeypadTypeText                      = 1,
	TransKeyKeypadTypeNumber                    = 2,
	TransKeyKeypadTypeTextWithPassword          = -1,
    TransKeyKeypadTypeTextWithPasswordOnly      = -3,
	TransKeyKeypadTypeNumberWithPassword        = -2,
    TransKeyKeypadTypeNumberWithPasswordOnly    = -4,
    TransKeyKeypadTypeTextWithPasswordLastShow  = -5,
    TransKeyKeypadTypeNumberWithPasswordLastShow  = -6
};
typedef NSInteger TransKeyKeypadType;

/*=============================================================================================================
 secureKeyboard(컨트롤분리) delegate
 =============================================================================================================*/
@protocol TransKeyWebDelegate<NSObject>

@optional

- (void)TransKeyDidBeginEditing:(TransWebKey *)transKey;
- (void)TransKeyDidEndEditing:(TransWebKey *)transKey;
- (void)TranskeyWillBeginEditing:(TransWebKey *)transKey;
- (void)TranskeyWillEndEditing:(TransWebKey *)transKey;
- (void)TransKeyInputKey:(NSInteger)keytype;
- (BOOL)TransKeyShouldInternalReturn:(TransWebKey *)transKey btnType:(NSInteger)type;
//키패드 생성이 완료된 후에 받는 delegate. 16.06.29. jiwan.
- (void)TransKeyEndCreating:(TransWebKey *)transKey;

@required
- (BOOL)TransKeyShouldReturn:(TransWebKey *)transKey;
@end

/*=============================================================================================================
 secureKeyboard(컨트롤분리) interface
 =============================================================================================================*/
@interface TransWebKey : UIView
@property (nonatomic, assign) id <TransKeyWebDelegate>delegate;
@property (nonatomic, retain) id parent;

/*=============================================================================================================
    MTranskey 기본 API
 =============================================================================================================*/
// 암호키 설정한다. 128bit
-(void)setSecureKey:(NSData*)securekey;
// 컨트롤 분리모드에서 디바이스지원 범위 설정
// secureKeyboard(컨트롤분리) support device 참조
- (void)mTK_SupportedByDeviceOrientation:(NSInteger)supported_;
// 보안 키패드의 타입 및 최대/최소 길이를 설정한다.
- (void)setKeyboardType:(TransKeyKeypadType)type maxLength:(NSInteger)maxlength minLength:(NSInteger)minlength;
// VoiceOver 사용
- (void)mTK_UseVoiceOver:(BOOL)bUse;
- (void)mTK_SetHiddenCompleteButton:(BOOL)hidden;
- (void)mTK_SetEnableCompleteButton:(BOOL)enable;
- (void)mTK_SetDisableCompleteButtonImageName:(NSString *)name;
- (void)mTK_SetCompleteButtonAccessibilityLabel:(NSString *)label;

- (void)mTK_textAlignCenter:(BOOL)bCenter;

- (void)mTK_UseShiftOptional:(BOOL)bUse;
// 보안키패드의 언어설정(0:한글(default), 1:영어)
// 한글 문구가 들어간 버튼만 이미지 변경(입력완료, 취소 등)
- (void)mTK_SetLanguage:(NSInteger)languageType;

/*=============================================================================================================
 MTranskey additional API
 =============================================================================================================*/
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
// textfield에 입력길이만큼 '*' 출력
- (void)setDummyCharacterWithLength:(NSInteger)length;
// 보안 키패드로 입력한 데이터 길이를 얻는다.
- (NSInteger)length;
// 암호화 키를 얻는다.
-(NSData*)getSecureKey;
// 보안 키패드를 사용하여 입력된 암호화 값을  얻는다.
- (NSString *)getCipherData;
- (NSString *)getCipherDataEx;
- (NSString *)getCipherDataExWithPadding;
// 보안키패드 랜덤키 설정
- (void)makeSecureKey;
// 보안 키패드를 사용하여 입력된 원문 값을 얻는다.
- (void)getPlainDataWithKey:(NSData*)key cipherString:(NSString*)cipherString plainString:(char*)plainData length:(NSInteger)length;
- (void)getPlainDataExWithKey:(NSData*)key cipherString:(NSString*)cipherString plainString:(char*)plainData length:(NSInteger)length;
- (void)getPlainDataExWithPaddingWithKey:(NSData*)key cipherString:(NSString*)cipherString plainString:(char*)plainData length:(NSInteger)length;

// TransKey의 키패드를 띄운다.
- (void)TranskeyBecomeFirstResponder;

// TransKey의 키패드를 내린다.
- (void)TranskeyResignFirstResponder;

// TransKey를 통해 입력한 데이터를 초기화한다.
- (void)clear;

// 입력문자의 사이즈 조절(텍스트모드)
- (void)mTK_SetSizeOfInputKeyImage:(CGFloat)width height:(CGFloat)height_;

// 입력문자의 사이즈 조절(암호모드)
- (void)mTK_SetSizeOfInputPwKeyImage:(CGFloat)width height:(CGFloat)height_;

// 현재 보안키패드에 설정된 언어 리턴
- (NSInteger)mTK_GetLanguage;

// 허용입력 초과시 메세지 박스 사용
- (void)mTK_ShowMessageIfMaxLength:(NSString*)message;

// 최소입력 미만시 메세지 박스 사용
- (void)mTK_ShowMessageIfMinLength:(NSString*)message;

// 버전
- (NSString*)mTK_GetVersion;

// 암호화 데이터 값
- (NSString*)mTK_GetSecureData;
- (NSString*)CK_GetSecureData;

//최상위 버튼의 Top 마진
- (void)mTK_SetHighestTopMargin:(int)height;

- (void)mTK_ClearDelegateSubviews;

- (NSInteger)mTK_GetInputLength;

- (void)mTK_EnableSamekeyInputDataEncrypt:(BOOL)bEnable;

- (void)mTK_setReArrangeKeypad:(BOOL)bReArrange;

- (void)mTK_UseKeypadAnimation:(BOOL)bUseAnimation;

- (void)mTK_setVerticalKeypadPosition:(int)position;

- (void)mTK_InputDone;
- (void)mTK_InputCancel;
- (void)mTK_InputBackSpace;

- (void)mTK_SetPBKDF_RandKey:(NSData*)randkey;
- (void)mTK_SetPBKDF_RandKey:(NSData*)randkey withSalt:(NSData *)salt withIterator:(NSInteger)iterator;

- (NSString*)getPBKDF2DataEncryptCipherData;
- (NSString*)getPBKDF2DataEncryptCipherDataEx;
- (NSString*)getPBKDF2DataEncryptCipherDataExWithPadding;

// 말풍선(balloon) 사용유무
- (void)mTK_SetUseBalloonImageButton:(BOOL)bUse;

- (void)mTK_DisableButtonEffect:(BOOL)bDisable;

//취소버튼 삭제
- (void) mTK_DisableCancelBtn : (BOOL) flag;

//오토포커싱 사용
- (void) mTK_SetAutoFocusing : (BOOL) flag;

// qwerty 키패드 높이 설정
- (void) mTK_SetHeight : (float) value;

// 키패드 높이 리턴
- (float) mTK_GetCurrentKeypadHeight;

// 더미 커스텀 이미지 사용
- (void) mTK_UseCustomDummy : (BOOL) flag;

// 커스텀 더미 스트링 (@"!@#$")
- (void) mTK_CustomDummyString : (NSString *) mDummyString;

// 드래그 기능 막는 옵션
- (void) mTK_DisableDragEvent : (BOOL) flag;

// color 세팅이 추가된 SetHint API
- (void)mTK_SetHint:(NSString *)desc font:(UIFont *)font textAlignment:(NSTextAlignment)alignment textColor:(UIColor *)color;

// 키패드 버튼 사이 간격 조절
- (void) mTK_SetBtnMarginRatio : (float) value;

// 키패드 입력완료 버튼 감춤/보이기 (동작중 사용가능)
- (void) mTK_SetCompleteBtnHide : (BOOL) flag;

// 공개키를 통한 암호문 패킷 생성
- (NSString*)mTK_EncryptSecureKey:(NSString*)publicKey cipherString:(NSString*)cipherString;

// 하단 Safe Area 적용 여부
- (void) mTK_SetBottomSafeArea : (BOOL) flag;

@end
