//
//  SessionRequest.h
//  verifip
//
//  Created by Aubrey Goodman on 7/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "ASIHTTPRequest.h"


@protocol SessionRequestDelegate
-(void)sessionCreated:(Session*)session;
-(void)sessionDeleted;
-(void)sessionInvalid;
-(void)sessionRequestFailed;
@end


@interface SessionRequest : NSObject <ASIHTTPRequestDelegate> {

	id<SessionRequestDelegate> delegate;
	
}

@property (nonatomic, assign) id<SessionRequestDelegate> delegate;

+(SessionRequest*)requestCreateSession:(Session*)session delegate:(id<SessionRequestDelegate>)delegate;
+(SessionRequest*)requestDeleteSession:(id<SessionRequestDelegate>)delegate;

@end
