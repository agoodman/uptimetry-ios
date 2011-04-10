//
//  Site.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "Site.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@implementation Site

@synthesize siteId, userId, url, email, lastSuccessfulAttempt;

+(Site*)siteWithDictionary:(NSDictionary*)dictionary
{
	int tUserId = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"];
	
	NSDateFormatter* tFormat = [[[NSDateFormatter alloc] init] autorelease];
	[tFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	
	Site* tSite = [[[Site alloc] init] autorelease];
	tSite.siteId = [dictionary objectForKey:@"id"];
	tSite.userId = [NSNumber numberWithInt:tUserId];
	tSite.url = [dictionary objectForKey:@"url"];
	tSite.email = [dictionary objectForKey:@"email"];
	NSString* tLastAttempt = [dictionary objectForKey:@"last_successful_attempt"];
	if( tLastAttempt && ![tLastAttempt isEqual:[NSNull null]] ) {
		tSite.lastSuccessfulAttempt = [tFormat dateFromString:tLastAttempt];
	}
	return tSite;
}

- (void)dealloc
{
	[userId release];
	[url release];
	[email release];
	[lastSuccessfulAttempt release];
	[super dealloc];
}

@end
