//
//  SessionRequest.m
//  verifip
//
//  Created by Aubrey Goodman on 7/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SessionRequest.h"
#import "NSString+SBJSON.h"


@interface SessionRequest (private)
-(id)initWithSession:(Session*)session delegate:(id<SessionRequestDelegate>)aDelegate;
-(void)clearPersistentSession;
@end

@implementation SessionRequest

static int ddLogLevel = LOG_LEVEL_VERBOSE;

@synthesize delegate;

+ (SessionRequest*)requestCreateSession:(Session *)session delegate:(id <SessionRequestDelegate>)delegate
{
	[[NSUserDefaults standardUserDefaults] setValue:session.email forKey:@"UserEmail"];
	[[NSUserDefaults standardUserDefaults] setValue:session.password forKey:@"UserPassword"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[SessionRequest alloc] initWithSession:session delegate:delegate];
}

+ (SessionRequest*)requestDeleteSession:(id <SessionRequestDelegate>)delegate
{
	return [[SessionRequest alloc] initWithSession:nil delegate:delegate];
}

- (id)initWithSession:(Session*)session delegate:(id<SessionRequestDelegate>)aDelegate
{
	self.delegate = aDelegate;

	ASIHTTPRequest* tReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[Session getRemoteCollectionPath]]];
	tReq.delegate = self;
	
	if( session ) {
		NSString* tJson = [session convertToRemoteExpectedType];
		[tReq appendPostData:[tJson dataUsingEncoding:NSISOLatin1StringEncoding]];
		[tReq addRequestHeader:@"Content-Type" value:@"application/json"];
	}else{
		[tReq setRequestMethod:@"DELETE"];
	}
	
	[tReq startAsynchronous];
		
	return self;
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
	DDLogVerbose(@"%@",[request url]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	DDLogVerbose(@"%@",[request responseString]);
	int tStatusCode = [request responseStatusCode];
	NSString* tAction = [request requestMethod];
	if( tStatusCode==200 && [tAction isEqualToString:@"DELETE"] ) {
		[self clearPersistentSession];
		[delegate sessionDeleted];
	}else if( tStatusCode==200 && [tAction isEqualToString:@"POST"] ) {
		@try {
			NSString* tJson = [request responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSDictionary* tSessionDict = [tDict objectForKey:@"session"];
			Session* tSession = [[[Session alloc] init] autorelease];
			tSession.userId = [tSessionDict objectForKey:@"user_id"];
//			tSession.rememberToken = [tSessionDict objectForKey:@"remember_token"];
			[[NSUserDefaults standardUserDefaults] setValue:tSession.userId forKey:@"UserId"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[delegate sessionCreated:tSession];
		}
		@catch (NSException * e) {
			[self clearPersistentSession];
			[delegate sessionRequestFailed];
		}
	}else if( tStatusCode==401 ) {
		[self clearPersistentSession];
		[delegate sessionInvalid];
	}else{
		[self clearPersistentSession];
		[delegate sessionRequestFailed];
	}
	[self autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self clearPersistentSession];

	int tStatusCode = [request responseStatusCode];
	if( tStatusCode==401 ) {
		[delegate sessionInvalid];
	}else{
		[delegate sessionRequestFailed];
	}
	[self autorelease];
}

- (void)clearPersistentSession
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserEmail"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPassword"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
