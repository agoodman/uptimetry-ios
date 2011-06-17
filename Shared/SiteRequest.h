//
//  SiteRequest.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Site.h"
#import "ASIHTTPRequest.h"


typedef void (^SiteBlock)(Site*);

@protocol SiteRequestDelegate
-(void)sitesReceived:(NSArray*)sites;
-(void)siteCreated:(Site*)site;
-(void)siteReceived:(Site*)site;
-(void)siteUpdated;
-(void)siteDeleted;
-(void)siteFieldsInvalid:(NSArray*)errors;
-(void)siteUnauthorized;
-(void)siteRequestFailed;
@end


@interface SiteRequest : NSObject <ASIHTTPRequestDelegate> {
	
	id<SiteRequestDelegate> delegate;
	NSString* action;
	
}

@property (nonatomic, assign) id<SiteRequestDelegate> delegate;
@property (nonatomic, retain) NSString* action;

+(void)requestCreateSite:(Site*)site success:(SiteBlock)success failure:(ASIBasicBlock)failure;
+(SiteRequest*)requestSites:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestCreateSite:(Site*)session delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestReadSite:(Site*)site delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestUpdateSite:(Site*)site delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestDeleteSite:(Site*)site delegate:(id<SiteRequestDelegate>)delegate;

@end
