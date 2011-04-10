//
//  SiteRequest.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "SiteRequest.h"
#import "NSString+SBJSON.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@interface SiteRequest (private)
-(id)initWithAction:(NSString*)action withObject:(Site*)site delegate:(id<SiteRequestDelegate>)aDelegate;
@end

@implementation SiteRequest

@synthesize action, delegate;

+ (SiteRequest*)requestSites:(id <SiteRequestDelegate>)aDelegate
{
	return [[SiteRequest alloc] initWithAction:@"index" withObject:nil delegate:aDelegate];
}

+ (SiteRequest*)requestCreateSite:(Site*)site delegate:(id<SiteRequestDelegate>)aDelegate
{
	return [[SiteRequest alloc] initWithAction:@"create" withObject:site delegate:aDelegate];
}

+ (SiteRequest*)requestReadSite:(Site *)site delegate:(id <SiteRequestDelegate>)aDelegate
{
	return [[SiteRequest alloc] initWithAction:@"show" withObject:site delegate:aDelegate];
}

+ (SiteRequest*)requestUpdateSite:(Site*)site delegate:(id<SiteRequestDelegate>)aDelegate
{
	return [[SiteRequest alloc] initWithAction:@"update" withObject:site delegate:aDelegate];
}

+ (SiteRequest*)requestDeleteSite:(Site *)site delegate:(id <SiteRequestDelegate>)delegate
{
	return [[SiteRequest alloc] initWithAction:@"destroy" withObject:site delegate:delegate];
}

- (id)initWithAction:(NSString*)aAction withObject:(Site*)site delegate:(id<SiteRequestDelegate>)aDelegate
{
	self.action = aAction;
	self.delegate = aDelegate;
	
	NSString* tPath;
	ASIHTTPRequest* tReq;
	if( [@"index" isEqualToString:aAction] || [@"create" isEqualToString:aAction] ) {
		tPath = [Site getRemoteCollectionPath];
	}else if( [@"show" isEqualToString:aAction] || [@"update" isEqualToString:aAction] || [@"destroy" isEqualToString:aAction] ) {
		tPath = [Site getRemoteElementPath:[NSString stringWithFormat:@"%@",site.siteId]];
	}else{
		[self release];
		return nil;
	}
	tReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tPath]];
	
	if( [@"create" isEqualToString:aAction] || [@"update" isEqualToString:aAction] ) {
		NSArray	 *tExclusions = [NSArray arrayWithObjects:[Site getRemoteClassIdName],@"createdAt",@"updatedAt",@"lastSuccessfulAttempt",@"userId",nil];
		NSString* tJson = [site performSelector:[Site getRemoteSerializeMethod] withObject:tExclusions];
		//		NSString* tJson = [site convertToRemoteExpectedType];
		[tReq appendPostData:[tJson dataUsingEncoding:NSISOLatin1StringEncoding]];
		[tReq addRequestHeader:@"Content-Type" value:@"application/json"];
	}
	
	if( [@"update" isEqualToString:aAction] ) {
		[tReq setRequestMethod:@"PUT"];
	}
	
	if( [@"destroy" isEqualToString:aAction] ) {
		[tReq setRequestMethod:@"DELETE"];
	}
	
	tReq.delegate = self;
	[tReq startAsynchronous];
	
	return self;
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
	DDLogVerbose(@"%@",[request responseString]);
	int tStatusCode = [request responseStatusCode];
	if( tStatusCode==401 ) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
		
	}else if ( tStatusCode==422 ) {
		// PUT or POST validation error
		NSString* tJson = [request responseString];
		NSDictionary* tDict = [tJson JSONValue];
		NSArray* tErrors = [tDict objectForKey:@"errors"];
		[delegate siteFieldsInvalid:tErrors];
	}else if( tStatusCode==200 && [action isEqualToString:@"index"] ) {
		// success
		@try {
			NSArray* tSiteArray = [[request responseString] JSONValue];
			NSMutableArray* tSites = [NSMutableArray array];
			for (NSDictionary* dict in tSiteArray) {
				NSDictionary* tSiteDict = [dict objectForKey:@"site"];
				[tSites addObject:[Site siteWithDictionary:tSiteDict]];
			}
			
			[delegate sitesReceived:tSites];
		}
		@catch (NSException * e) {
			DDLogError(@"%@",e);
			[delegate siteRequestFailed];
		}
	}else if( tStatusCode==200 && ([action isEqualToString:@"show"] || [action isEqualToString:@"create"]) ) {
		// success
		@try {
			NSString* tJson = [request responseString];
			NSDictionary* tDict = [tJson JSONValue];
			NSDictionary* tSiteDict = [tDict objectForKey:@"site"];
			Site* tSite = [Site siteWithDictionary:tSiteDict];
			[delegate siteReceived:tSite];
		}
		@catch (NSException * e) {
			[delegate siteRequestFailed];
		}
	}else if( tStatusCode==200 && [action isEqualToString:@"update"] ) {
		[delegate siteUpdated];
	}else if( tStatusCode==200 && [action isEqualToString:@"destroy"] ) {
		[delegate siteDeleted];
	}else{
		// unknown error
		[delegate siteRequestFailed];
	}
	[self autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	DDLogVerbose([request responseString]);
	int tStatusCode = [request responseStatusCode];
	if( tStatusCode==401 ) {
		[delegate siteUnauthorized];
	}else{
		[delegate siteRequestFailed];
	}
	[self autorelease];
}

- (void)dealloc
{
	[action release];
	[super dealloc];
}


@end
