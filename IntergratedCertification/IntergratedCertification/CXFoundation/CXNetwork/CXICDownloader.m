//
//  CXICDownloader.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "CXICDownloader.h"
//#import "SHSPConstants.h"

@interface CXICDownloader() {
    NSURLResponse*  _response;
}

@property (strong, nonatomic) NSMutableData *downloadData;

@end


@implementation CXICDownloader

- (id)initWithTag:(NSString*)tag
{
	self = [super init];
	if (self) {
		self.downLoaderTag	= tag;
	}
	return self;
}

- (void)download:(NSString*)path{
	self.path		= path;

	NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:path]
											  cachePolicy:NSURLRequestReloadIgnoringCacheData
										  timeoutInterval:60.0];
	NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
    //SHSPLog(@"Download Start! %@", self.path );
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    
	self.downloadData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.downloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(onDownloadFailed:error:)]) {
		[_delegate onDownloadFailed:self error:error];
	}
	
    self.delegate = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger statusCode = 200;
    if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = ((NSHTTPURLResponse*)_response).statusCode;
    }
    
    if( statusCode >= 400 ) {
        NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil];
        
        //SHSPLog(@"Download failed! %@ Error - %@(%ld))", self.path, [error localizedDescription], (long)statusCode);
        if ([_delegate respondsToSelector:@selector(onDownloadFailed:error:)]) {
            [_delegate onDownloadFailed:self error:error];
        }
        
        self.delegate = nil;
        return;
    }
    
    //SHSPLog(@"Download Succeeded! Received %@ %lld bytes of data", self.path, [@([self.downloadData length]) longLongValue]);

    if ([_delegate respondsToSelector:@selector(onDownloadFinished:stream:)]) {
		[_delegate onDownloadFinished:self stream:self.downloadData];
	}
    
    self.delegate = nil;
}

@end
