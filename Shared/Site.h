//
//  Site.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveResource.h"


@interface Site : NSObject {

	NSNumber* siteId;
	NSNumber* userId;
	NSString* url;
	NSString* email;
	NSDate* lastSuccessfulAttempt;
	
}

@property (retain) NSNumber* siteId;
@property (retain) NSNumber* userId;
@property (retain) NSString* url;
@property (retain) NSString* email;
@property (retain) NSDate* lastSuccessfulAttempt;

+(Site*)siteWithDictionary:(NSDictionary*)dictionary;


@end
