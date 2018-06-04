//
//  CXICSession.m
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICNetworkError.h"
#import "CXICSession.h"
#import "CXICTransaction.h"

@interface CXICSessionOperator : NSOperation

@property (strong  , nonatomic) CXICSession*		session;
@property (strong  , nonatomic) CXICTransaction*	transaction;

@end

@interface CXICSession () {
	NSOperationQueue*		_transactionQueue;
}

- (void)transmitWorker:(CXICTransaction*)transaction;

@end

@implementation CXICSessionOperator

- (void)main {
	[self.session transmitWorker:self.transaction];
}

@end


@implementation CXICSession

- (id)init {
	self = [super init];
	if( self ) {
		_transactions		= [[NSMutableDictionary alloc] init];
		_transactionQueue	= [[NSOperationQueue alloc] init];
        _connectionTimeout  = 10;
		
		[_transactionQueue setMaxConcurrentOperationCount:10];
	}
	
	return self;
}

- (void)cancelAllTransactions {
	[_transactionQueue cancelAllOperations];
	
	NSArray* keys = [_transactions allKeys];
	for( NSString* key in keys ) {
		CXICTransaction* transaction = _transactions[key];
		
		if( [transaction.delegate respondsToSelector:@selector(transactionDidCanceled:)] )
			[transaction.delegate performSelectorOnMainThread:@selector(transactionDidCanceled:) withObject:transaction waitUntilDone:NO];
		
		transaction.delegate = nil;
	}
	
	[_transactions removeAllObjects];
}

- (void)transmitTransaction:(CXICTransaction*)transaction {
	@synchronized(_transactions) {
		_transactions[transaction.identifier] = transaction;
	}
	
	CXICSessionOperator* operator = [[CXICSessionOperator alloc] init];
	
	operator.session		= self;
	operator.transaction	= transaction;
	
	[_transactionQueue addOperation:operator];
}

- (void)transmitSynchronousTransaction:(CXICTransaction*)transaction {
	transaction.synchronous = YES;
	
	@synchronized(_transactions) {
		_transactions[transaction.identifier] = transaction;
	}
	
	transaction.condition = [[NSCondition alloc] init];
	if( [self doSendingWithTransaction:transaction] == CXICSessionSendTypeAsync )
        [transaction.condition wait];
	
	if( transaction.error != nil ) {
		
	}
}

- (void)transmitWorker:(CXICTransaction*)transaction {
	@try {
        [self performSelectorOnMainThread:@selector(performTransmitOnMainThread:) withObject:transaction waitUntilDone:NO];
		
		BOOL flags = [self willTransmit:transaction];
        if( flags ) {
            [self doSendingWithTransaction:transaction];
        }
        
	}
	@catch (NSException *exception) {
		NSError* error = nil;
		if( [exception.name isEqualToString:CXICNetworkException] ) {
			error = exception.userInfo[@"error"];
		}
		
        if( error == nil ) {
            error = [NSError errorWithDomain:exception.name code:0 userInfo:@{NSLocalizedDescriptionKey:exception.reason, @"tran":transaction}];
        }
        
        NSString* message = [self stringForError:error];
        error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:message, @"tran":transaction}];
        
        [self willTransmitException:transaction exception:exception];
		
		[self performSelectorOnMainThread:@selector(performErrorOnMainThread:) withObject:error waitUntilDone:NO];

        transaction.error = error;
		if( [transaction.delegate respondsToSelector:@selector(transactionDidFailed:)] )
			[transaction.delegate performSelectorOnMainThread:@selector(transactionDidFailed:) withObject:transaction waitUntilDone:NO];

	}
	@finally {
		
	}
}

- (void)incomingResponse:(NSData*)response ofIdentifier:(NSString*)identifier {
	CXICTransaction* transaction = nil;
	@try {
		@synchronized(_transactions) {
			transaction = self.transactions[identifier];
			if( transaction != nil ) {
				[self.transactions removeObjectForKey:identifier];
			}
		}

		//TODO: 강차장님 체크 필요
//		if( !transaction.synchronous )
//			[self performSelectorOnMainThread:@selector(performIncomingOnMainThread:) withObject:transaction waitUntilDone:NO];

		transaction.data = response;
		
		if( !transaction.synchronous ) {
			if([self willResponse:transaction]) {
				if( !transaction.synchronous ) {
					if( [transaction.delegate respondsToSelector:@selector(transactionDidFinished:)] )
						[transaction.delegate performSelectorOnMainThread:@selector(transactionDidFinished:) withObject:transaction waitUntilDone:NO];

					[self performSelectorOnMainThread:@selector(performIncomingOnMainThread:) withObject:transaction waitUntilDone:NO];
				
					transaction.delegate = nil;
				}
			}
		}
	}
	@catch (NSException *exception) {
		NSError* error = nil;
		if( [exception.name isEqualToString:CXICNetworkException] ) {
			error = exception.userInfo[@"error"];
		}
		
		if( error == nil ) {
			error = [NSError errorWithDomain:exception.name code:0 userInfo:@{NSLocalizedDescriptionKey:exception.reason, @"tran":transaction}];
		}
        
        NSString* message = [self stringForError:error];
		transaction.error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:message, @"tran":transaction}];
		if( !transaction.synchronous ) {
			[self performSelectorOnMainThread:@selector(performErrorOnMainThread:) withObject:transaction.error waitUntilDone:NO];

			if( [transaction.delegate respondsToSelector:@selector(transactionDidFailed:)] )
				[transaction.delegate performSelectorOnMainThread:@selector(transactionDidFailed:) withObject:transaction waitUntilDone:NO];
		}
		
		transaction.delegate = nil;
	}
	@finally {
		if( transaction.synchronous ) {
			[transaction.condition signal];
		}
	}
}

- (void)performTransmitOnMainThread:(CXICTransaction*)transaction {
	if( [self.delegate respondsToSelector:@selector(session:transmitTransaction:)] )
		[self.delegate session:self transmitTransaction:transaction];
}

- (void)performIncomingOnMainThread:(CXICTransaction*)transaction {
	if( [self.delegate respondsToSelector:@selector(session:incomingTransaction:)] )
		[self.delegate session:self incomingTransaction:transaction];
}

- (void)performErrorOnMainThread:(NSError*)error {
	if( [self.delegate respondsToSelector:@selector(session:didFailWithError:)] )
		[self.delegate session:self didFailWithError:error];
}

- (CXICSessionSendType)doSendingWithTransaction:(CXICTransaction*)transaction { return CXICSessionSendTypeSync; }
- (BOOL)willTransmit:(CXICTransaction*)transaction { return YES; }
- (BOOL)willResponse:(CXICTransaction*)transaction { return YES; }
- (void)willTransmitException:(CXICTransaction*)transaction exception:(NSException*)exception{}
- (NSString*)stringForError:(NSError*)error { return [error localizedDescription]; }

@end



