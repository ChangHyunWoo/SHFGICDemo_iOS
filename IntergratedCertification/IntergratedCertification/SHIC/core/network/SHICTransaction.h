//
//  SHICTransaction.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 11. 18..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "CXICURLTransaction.h"

@interface SHICTransaction : CXICURLTransaction

@property (strong  , nonatomic) NSString*				code;
@property (strong  , nonatomic) NSString*				uri;
@property (strong  , nonatomic) NSString*				authority;
@property (strong  , nonatomic) NSString*				accessToken;
@property (readonly, nonatomic) NSMutableDictionary*	request;
@property (readonly, nonatomic) NSMutableDictionary*	response;
@property (strong, nonatomic) NSMutableDictionary*		option;

@property (readonly, nonatomic) NSMutableDictionary*	requestHead;
@property (readonly, nonatomic) NSMutableDictionary*	requestBody;
@property (readonly, nonatomic) NSDictionary*			responseHead;
@property (readonly, nonatomic) NSDictionary*			responseBody;
@property (assign, nonatomic) BOOL						errorPopupEnabled;

- (void)putForOptionDictionary:(NSDictionary*)dictionary;
- (void)putValue:(NSString*)value forHeader:(NSString*)key;
- (void)putForHeaderDictionary:(NSDictionary*)dictionary;
- (void)putValue:(id)value forBody:(NSString*)key;
- (void)putDictionary:(NSDictionary*)dictionary;
- (void)transmit;
- (void)putUri:(NSString*)uri ;
- (void)transmitWithFinished:(void (^ __nullable)(SHICTransaction* tr))finished failed:(void (^ __nullable)(SHICTransaction* tr))failed cancel:(void (^ __nullable)(SHICTransaction* tr))cancel;

@end
