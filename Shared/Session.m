//
//  Session.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize userId, email, password;

+ (NSString*)getRemoteCollectionName
{
	return @"session";
}

@end
