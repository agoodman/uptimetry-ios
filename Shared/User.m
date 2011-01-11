//
//  User.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "User.h"
#import "ORConnection.h"
#import "Response.h"


@implementation User

@synthesize userId, firstName, lastName, email, password, termsOfServiceAccepted, emailConfirmed;

+ (User*)findCurrent
{
	NSString* tPath = [NSString stringWithFormat:@"%@user%@",[User getRemoteSite],[User getRemoteProtocolExtension]];
	Response* tRsp = [ORConnection get:tPath withUser:nil andPassword:nil];
	User* tUser = [User performSelector:[User getRemoteParseDataMethod] withObject:tRsp.body];
	return tUser;
}

+ (User*)userWithDictionary:(NSDictionary*)dict
{
	User* tUser = [[[User alloc] init] autorelease];
	tUser.userId = [dict objectForKey:@"id"];
	tUser.firstName = [dict objectForKey:@"first_name"];
	tUser.lastName = [dict objectForKey:@"last_name"];
	tUser.email = [dict objectForKey:@"email"];
	tUser.termsOfServiceAccepted = [dict objectForKey:@"terms_of_service_accepted"];
	tUser.emailConfirmed = [dict objectForKey:@"email_confirmed"];
	return tUser;
}

//+ (NSString*)getRemoteCollectionName
//{
//	return @"user";
//}

- (void)dealloc
{
	[userId release];
	[firstName release];
	[lastName release];
	[email release];
	[password release];
	[super dealloc];
}

@end
