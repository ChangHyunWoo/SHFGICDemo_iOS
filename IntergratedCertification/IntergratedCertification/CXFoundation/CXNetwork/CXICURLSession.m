//
//  CXICURLSession.m
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICURLSession.h"
#import "CXICURLTransaction.h"
#import "CXICNetworkError.h"
//#import "SHSPConstants.h"

static BOOL __CXICURLSessionTestModeEnabled = NO;

@interface NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end

@implementation NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    if (__CXICURLSessionTestModeEnabled) {
        return YES;
    }

    return NO;
}

@end


@implementation CXICURLSession

+ (void)testModeEnabled {
    __CXICURLSessionTestModeEnabled = YES;
}

- (id)init {
    self = [super init];
    if( self ) {
        self.method         = @"POST";
        self.encodingTarget = NSUTF8StringEncoding;
        self.encodingLocal  = NSUTF8StringEncoding;
    }
    
    return self;
}


- (CXICSessionSendType)doSendingWithTransaction:(CXICTransaction*)transaction {
    NSString*        target           = self.target;
    NSString*        method           = self.method;
    
    if ([transaction isKindOfClass:[CXICURLTransaction class]])
        target = ((CXICURLTransaction*)transaction).target;
    
    NSURL *url = [NSURL URLWithString:[target stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval:(self.connectionTimeout + transaction.timeout)];
	
    if ([transaction isKindOfClass:[CXICURLTransaction class]]) {
        CXICURLTransaction* urlTransaction = (CXICURLTransaction*)transaction;
        
        if( urlTransaction.encodingTarget != -1 )
            urlTransaction.encodingTarget = self.encodingTarget;
        
        if( urlTransaction.encodingLocal != -1 )
            urlTransaction.encodingLocal  = self.encodingLocal;
    }
    
    NSData* data = transaction.data;
    if ([transaction isKindOfClass:[CXICURLTransaction class]]) {
        CXICURLTransaction* urlTransaction = (CXICURLTransaction*)transaction;
        
        NSArray* allKeys = [urlTransaction.httpHeader allKeys];
        for (NSString* field in allKeys) {
            [request setValue:urlTransaction.httpHeader[field] forHTTPHeaderField:field];
        }
        if( [urlTransaction.method length] > 0  )
            method = urlTransaction.method;
    }
    
    [request setHTTPMethod:method];
    
    if( [method isEqualToString:@"GET"] ) {
        
    } else {
        [request setHTTPBody:data];
    }
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil) {
//        NSDictionary* headerFields = [(NSHTTPURLResponse *)response allHeaderFields];
//        NSInteger statusCode = 200;
//        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//            statusCode = ((NSHTTPURLResponse*)response).statusCode;
//        }
        
//        if( statusCode != 200 )
//            [NSException raise:@"Exception" format:@"%@(%@)", [error localizedDescription], [error localizedFailureReason]];
        
        [self incomingResponse:received ofIdentifier:transaction.identifier];
    } else {
		switch (error.code) {
			case NSURLErrorTimedOut:
			case NSURLErrorCannotConnectToHost:
			case NSURLErrorNetworkConnectionLost:
			case NSURLErrorNotConnectedToInternet: {
				@throw [NSException exceptionWithName:CXICNetworkException reason:[error localizedDescription] userInfo:@{@"error":error, @"tran":transaction}];
			}break;
				
			default:
				[NSException raise:@"Exception" format:@"%@(%@)", [error localizedDescription], [error localizedFailureReason]];
				break;
		}
    }
    
    return CXICSessionSendTypeSync;
}

- (BOOL)willTransmit:(CXICTransaction*)transaction{
	return YES;
}

- (void)willTransmitException:(CXICTransaction*)transaction exception:(NSException*)exception{
	
}

@end




















