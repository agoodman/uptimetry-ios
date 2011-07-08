//
//  UserRequest.m
//  VerifipMobile
//
//  Created by Aubrey Goodman on 8/19/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "UserRequest.h"


@interface UserRequest (private)
-(id)initWithAction:(NSString*)action withObject:(User*)user delegate:(id<UserRequestDelegate>)aDelegate;
@end

@implementation UserRequest

static int ddLogLevel = LOG_LEVEL_ERROR;

@synthesize delegate, action;

+ (void)requestUser:(int)aUserId success:(UserBlock)successBlock failure:(ErrorBlock)failureBlock
{
	NSString* tPath = [NSString stringWithFormat:@"%@user.json",[User getRemoteSite]];
	ASIHTTPRequest* tRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tPath]];
	[tRequest setCompletionBlock:^{
		int tStatusCode = [tRequest responseStatusCode];
		if( tStatusCode==200 ) {
			NSString* tJson = [tRequest responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSDictionary* tUserDict = [tDict objectForKey:@"user"];
			User* tUser = [User userWithDictionary:tUserDict];
			successBlock(tUser);
		}else{
			failureBlock(tStatusCode, [tRequest responseString]);
		}
	}];
	[tRequest setFailedBlock:^{
		int tStatusCode = [tRequest responseStatusCode];
		failureBlock(tStatusCode, [tRequest responseString]);
	}];
	[tRequest startAsynchronous];
}

+ (UserRequest*)requestCreateUser:(User *)user delegate:(id <UserRequestDelegate>)delegate
{
	return [[UserRequest alloc] initWithAction:@"create" withObject:user delegate:delegate];
}

+ (UserRequest*)requestReadUser:(User *)user delegate:(id <UserRequestDelegate>)delegate
{
	return [[UserRequest alloc] initWithAction:@"show" withObject:user delegate:delegate];
}

+ (UserRequest*)requestUpdateUser:(User *)user delegate:(id <UserRequestDelegate>)delegate
{
	return [[UserRequest alloc] initWithAction:@"update" withObject:user delegate:delegate];
}

+ (UserRequest*)requestDeleteUser:(User*)user delegate:(id <UserRequestDelegate>)delegate
{
	return [[UserRequest alloc] initWithAction:@"destroy" withObject:user delegate:delegate];
}

- (id)initWithAction:(NSString*)aAction withObject:(User*)user delegate:(id<UserRequestDelegate>)aDelegate
{
	self.action = aAction;
	self.delegate = aDelegate;
	
	NSString* tPath;
	ASIHTTPRequest* tReq;
	if( [@"index" isEqualToString:aAction] || [@"create" isEqualToString:aAction] ) {
		tPath = [User getRemoteCollectionPath];
	}else if( [@"show" isEqualToString:aAction] || [@"update" isEqualToString:aAction] ) {
		tPath = [NSString stringWithFormat:@"%@user%@",[User getRemoteSite],[User getRemoteProtocolExtension]];
	}else{
		[self release];
		return nil;
	}
	tReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tPath]];
	
	if( [@"create" isEqualToString:aAction] || [@"update" isEqualToString:aAction] ) {
		NSArray	 *tExclusions = [NSArray arrayWithObjects:[User getRemoteClassIdName],@"createdAt",@"updatedAt",@"comments",@"links",nil];
		NSString* tJson = [user performSelector:[User getRemoteSerializeMethod] withObject:tExclusions];
//		NSString* tJson = [user convertToRemoteExpectedType];
		[tReq appendPostData:[tJson dataUsingEncoding:NSISOLatin1StringEncoding]];
		[tReq addRequestHeader:@"Content-Type" value:@"application/json"];
	}
	
	if( [@"update" isEqualToString:aAction] ) {
		[tReq setRequestMethod:@"PUT"];
	}
	
	tReq.delegate = self;
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
	if( tStatusCode==200 && [action isEqualToString:@"create"] ) {
		@try {
			NSString* tJson = [request responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSDictionary* tUserDict = [tDict objectForKey:@"user"];
			User* tUser = [User userWithDictionary:tUserDict];
			[delegate userCreated:tUser];
		}
		@catch (NSException * e) {
			[delegate userRequestFailed];
		}
	}else if( tStatusCode==422 && [action isEqualToString:@"create"] ) {
		@try {
			NSString* tJson = [request responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSArray* tErrors = [tDict objectForKey:@"errors"];
			[delegate userFieldsInvalid:tErrors];
		}
		@catch (NSException * e) {
			[delegate userRequestFailed];
		}
	}else if( tStatusCode==200 && [action isEqualToString:@"update"] ) {
		[delegate userUpdated];
	}else if( tStatusCode==200 && [action isEqualToString:@"destroy"] ) {
		[delegate userDeleted];
	}else if( tStatusCode==200 && [action isEqualToString:@"show"] ) {
		@try {
			NSString* tJson = [request responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSDictionary* tUserDict = [tDict objectForKey:@"user"];
			User* tUser = [User userWithDictionary:tUserDict];
			[delegate userReceived:tUser];
		}
		@catch (NSException * e) {
			[delegate userRequestFailed];
		}
	}else if( tStatusCode==401 ) {
		[delegate userInvalid];
	}else{
		[delegate userRequestFailed];
	}
	[self autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	int tStatusCode = [request responseStatusCode];
	if( tStatusCode==401 ) {
		[delegate userInvalid];
	}else{
		[delegate userRequestFailed];
	}
	[self autorelease];
}

@end
