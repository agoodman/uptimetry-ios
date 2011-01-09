//
//  UserRequest.h
//  VerifipMobile
//
//  Created by Aubrey Goodman on 8/19/10.
//  Copyright 2010 VerifIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"


@protocol UserRequestDelegate
-(void)userCreated:(User*)user;
-(void)userReceived:(User*)user;
-(void)userDeleted;
-(void)userFieldsInvalid:(NSArray*)errors;
-(void)userRequestFailed;
@end


@interface UserRequest : NSObject <ASIHTTPRequestDelegate> {
	
	id<UserRequestDelegate> delegate;
	NSString* action;
	
}

@property (nonatomic, assign) id<UserRequestDelegate> delegate;
@property (nonatomic, retain) NSString* action;

+(UserRequest*)requestCreateUser:(User*)user delegate:(id<UserRequestDelegate>)delegate;
+(UserRequest*)requestReadUser:(User*)user delegate:(id<UserRequestDelegate>)delegate;
+(UserRequest*)requestDeleteUser:(id<UserRequestDelegate>)delegate;

@end
