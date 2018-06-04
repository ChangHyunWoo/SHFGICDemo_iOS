//
//  AuthDBHelper.h
//  fidoclient
//
//  Created by raon on 2015. 10. 7..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFC_FMDB.h"

#import "KeyInfo.h"
#import "KeyInfoDAO.h"

@interface AuthDBHelper : NSObject

+ (id) sharedInstance;
    
// DB Query
//+(bool) createDatabase;
//+(bool) checkDatabase;

// ETC Query
//-(void) insertDummyData;
-(void) printKeyInfoTbl;

// Select Query
//-(KeyInfo *) getKeyInfo:(NSString *) aaid;    //임시로 사용 중
-(KeyInfo *) getKeyInfo:(NSString *) aaid withKeyId:(NSData *) keyId;
-(NSMutableArray *) getKeyIds:(NSString *) aaid withAppId:(NSString *) appId;                           //ASM'DB Helper
-(NSMutableArray *) getKeyHandles:(NSString *) aaid withAppId:(NSString *) appId;                       //ASM'DB Helper, NSData Array
-(NSData *) getKeyHandle:(NSString *) aaid withAppId:(NSString *) appId withKeyId:(NSData *) keyId;     //ASM'DB Helper
//-(bool) changePriKey:(NSData *)preWrap newWrap:(NSData *)newWrap withAAID:(NSString *) aaid;
-(bool) changePriKey:(NSData *)preWrap newWrap:(NSData *)newWrap withAAID:(NSString *) aaid withKeyId:(NSData *) keyId;
// Insert Query
-(bool) insertKeyInfo:(KeyInfo *) keyInfo;

// Update Query
-(bool) updateKeyInfo:(KeyInfo *) keyInfo;

// Delete Query
-(bool) deleteAllofAAID:(NSString *) aaid;
-(bool) deleteKeyInfo:(NSString *) aaid withKeyId:(NSData *) keyId;

//////////////////////////////////////////////////////////
//-(void) insertAuthSQL:(NSString *)sqlQuery;
//-(void) updateAuthSQL:(NSString *)sqlQuery;
//-(void) deleteAuthSQL:(NSString *)sqlQuery;

//////////////////////////////////////////////////////////

@end
