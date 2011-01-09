//
//  User.h
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2010 VerifIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveResource.h"


@interface User : NSObject {

	NSNumber* userId;
	NSString* firstName;
	NSString* lastName;
	NSString* email;
	NSString* password;
	BOOL termsOfServiceAccepted;
	BOOL emailConfirmed;
	
}

@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@property BOOL termsOfServiceAccepted;
@property BOOL emailConfirmed;

+(User*)userWithDictionary:(NSDictionary*)dict;

@end
