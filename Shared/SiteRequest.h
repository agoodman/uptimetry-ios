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


@protocol SiteRequestDelegate
-(void)sitesReceived:(NSArray*)sites;
-(void)siteCreated:(Site*)site;
-(void)siteReceived:(Site*)site;
-(void)siteUpdated;
-(void)siteDeleted;
-(void)siteFieldsInvalid:(NSArray*)errors;
-(void)siteRequestFailed;
@end


@interface SiteRequest : NSObject <ASIHTTPRequestDelegate> {
	
	id<SiteRequestDelegate> delegate;
	NSString* action;
	
}

@property (nonatomic, assign) id<SiteRequestDelegate> delegate;
@property (nonatomic, retain) NSString* action;

+(SiteRequest*)requestSites:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestCreateSite:(Site*)session delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestReadSite:(Site*)user delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestUpdateSite:(Site*)user delegate:(id<SiteRequestDelegate>)delegate;
+(SiteRequest*)requestDeleteSite:(id<SiteRequestDelegate>)delegate;

@end
