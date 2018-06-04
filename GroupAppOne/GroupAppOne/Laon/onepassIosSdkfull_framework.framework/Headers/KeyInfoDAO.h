//
//  KeyInfoDAO.h
//  fidoclient
//
//  Created by raon on 2015. 10. 7..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFC_FMDB.h"



//KeyInfo Table Name
static NSString* KeyInfo_Table_Name = @"keyinfotbl";              //키 정보 테이블명

//KeyInfo Column Name
static NSString* KeyInfo_Col_AAID = @"aaid";                      //AAID 필드 이름
static NSString* KeyInfo_Col_KeyId = @"keyid";                    //key id 필드 이름
static NSString* KeyInfo_Col_SignCounter = @"signcounter";        //signcounter 필드 이름

//KeyInfo Column Name(나중 ASM DB로 들어가야 함)
static NSString* KeyInfo_Col_PriKey = @"prikey";
static NSString* KeyInfo_Col_Username = @"username";
static NSString* KeyInfo_Col_AppId = @"appid";



/**
 * DB에 Key 관련 정보(keyinfotbl)를 관리하는 DAO 기능을 제공한다. keyinfotble의 각 필드, 테이블 생성 SQL
 * 문, Drop SQL 문을 정의한다. Cursor로부터 각 필드의 정보를 조회하는 기능을 제공한다.
 *
 * @author Administrator
 *
 */
@interface KeyInfoDAO : NSObject

//method(get SQL문)
+ (NSString *) getCreateStatement;
+ (NSString *) getDropTableStatement;

//method(DB to data)
+ (NSData *) getAAID:(RFC_FMResultSet *)rs;
+ (NSData *) getKeyId:(RFC_FMResultSet *)rs;
+ (int) getSignCounter:(RFC_FMResultSet *)rs;

//method(DB to data)(나중 ASM DB로 들어가야 함)
+ (const unsigned char *)  getPriKey:(RFC_FMResultSet *)rs;
+ (NSString *) getUserName:(RFC_FMResultSet *)rs;
+ (NSString *) getAppId:(RFC_FMResultSet *)rs;

@end

