//
//  AsmProc.h
//  fidoclient
//
//  Created by raon on 2015. 9. 24..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASMPROC_SUCCESS         0x00
#define ASMPROC_CANCEL          0x01
#define ASMPROC_FAILED          0x02
#define ASMPROC_LICENSEERROR    0xFC
#define ASMPROC_TIMEOVER        0xFD
#define ASMPROC_TRYCOUNTOVER    0xFE
#define ASMPROC_UNKNOW          0xFF

#define ASMPROC_RES             @"res"
#define ASMPROC_DATA            @"data"
#define ASMPROC_RESULT          @"result"

@protocol ASMAppDelegate <NSObject>
- (void) receiveASMMessage:(NSString *)uafMsgJSON withRequestCode:(int)requestCode error:(NSError **)error;
@end

@protocol ASMHelperDelegate <NSObject>                                          // memo : prev-name is ASMHandlerDelegate <NSObject>
- (void) receiveDataForHelper:(NSDictionary *)response error:(NSError **)error; // ASM으로 결과를 return
- (NSData *) getUniData;                                                        // ASM에서 인증장치를 위한 Unique ID를 get
@end

@protocol ASMPreHelperDelegate <NSObject>
- (void) receiveDataForProc:(NSDictionary *)response error:(NSError **)error;
@end

@protocol ASMHandlerDelegate <NSObject>
- (void) sendMessage:(int)what;
- (void) setStatusCode:(int)statusCode;
- (void) setWrapK:(NSData *)wrapK;
- (int) getCurrentStage;
@end

@protocol ASMInnerDelegate <NSObject>
- (id) innerObjInit:(id<ASMHelperDelegate>)handler; // ASMHelper의 delegate
- (void) innerAsyncSetupDlg;                        // 인증장치의 등록처리
- (void) innerAsyncAuthDlg:(int)tryCnt;             // 인증장치의 인증처리
- (void) innerAsyncSettingDlg;                      // 인증장치의 세팅처리
- (BOOL) innerResetEnrollment;                      // 인증장치 데이터 내용 초기화
- (BOOL) innerIsEnrollment;                         // 인증장치 가입 여부
- (BOOL) innerArrangeData;                          // 인증장치 임시 데이터 초기화
@end

#define hdlr_DATA       @"hdlr_DATA"        //NSNumber(int)
#define hdlr_RESULTCODE @"hdlr_RESULTCODE"  //NSData
enum hdlr_data {hdlr_success=0, hdlr_fail, hdlr_cancel, hdlr_requestSET, hdlr_requestAUTH}; //요청(requestSET, requestAUTH), 상태(success, fail, cancel)

@interface AsmProc : NSObject
@end
