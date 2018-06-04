//
//  KeyInfo.h
//  fidoclient
//
//  Created by raon on 2015. 10. 7..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 인증장치에서 사용자 등록시 생성한 사용자 개인키 아이디와 서명한 서명 counter를 관리한다.
 *
 * @author Administrator
 *
 */
@interface KeyInfo : NSObject

@property (nonatomic, strong) NSString* AAID;
@property (nonatomic, strong) NSData* keyId;
@property int signCounter;
@property (nonatomic, strong) NSData* priKey;       // (나중 ASM DB의 keyHandle 안으로 들어가야 함)
@property (nonatomic, strong) NSString* userName;   // (나중 ASM DB의 keyHandle 안으로 들어가야 함)
@property (nonatomic, strong) NSString* appId;      // (나중 ASM DB의 keyHandle 안으로 들어가야 함)

@end
