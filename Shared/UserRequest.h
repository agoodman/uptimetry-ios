//
//  UserRequest.h
//  VerifipMobile
//
//  Created by Aubrey Goodman on 8/19/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"


typedef void (^UserBlock)(User*);


@protocol UserRequestDelegate
-(void)userCreated:(User*)user;
-(void)userReceived:(User*)user;
-(void)userUpdated;
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

+(void)requestUser:(int)aUserId startBlock:(ASIBasicBlock)startBlock successBlock:(UserBlock)successBlock failureBlock:(ErrorBlock)failureBlock;
+(void)requestCreateUser:(User*)aUser startBlock:(ASIBasicBlock)startBlock successBlock:(UserBlock)successBlock failureBlock:(ErrorBlock)failureBlock;
+(UserRequest*)requestCreateUser:(User*)user delegate:(id<UserRequestDelegate>)delegate;
+(UserRequest*)requestReadUser:(User*)user delegate:(id<UserRequestDelegate>)delegate;
+(UserRequest*)requestUpdateUser:(User*)user delegate:(id<UserRequestDelegate>)delegate;
+(UserRequest*)requestDeleteUser:(id<UserRequestDelegate>)delegate;

@end
