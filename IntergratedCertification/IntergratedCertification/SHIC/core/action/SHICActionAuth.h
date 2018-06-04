//
//  SHICActionAuth.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 11. 2..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <IntergratedCertification/IntergratedCertification.h>

@interface SHICActionAuth : SHICAction

/**
 * Target앱의 세션 연장 호출
 */
- (void)extendSession;
/**
 * Target앱에 빠른이체에서 사용하는 지문인증 가능 여부 확인
 */
- (void)isFIDOEnabled:(RunBlockAfterAction)block;
/**
 * Target앱의 FIDO 인증 호출
 */
- (void)verifyFIDO:(NSDictionary*)parameter block:(RunBlockAfterAction)block;
/**
 * 은행을 제외한 그룹사에서 SAML토큰 생성시 필요한 추가 데이터 세팅
 */
- (NSDictionary*)onAuthorized;
/**
 * 은행을 제외한 그룹사에서 전문 요청시 필요한 추가 데이터 세팅
 */
- (NSDictionary*)onTransmitWithTarget:(NSString*)target;
/**
 * 타켓 앱 업데이트를 위한 action
 */
- (NSDictionary*)update;

@end
