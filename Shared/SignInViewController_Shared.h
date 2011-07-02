//
//  SignInViewController_Shared.h
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionRequest.h"


@protocol SignInDelegate
-(void)cancelSignIn;
-(void)signedInWithUserId:(int)userId;
@end


@interface SignInViewController_Shared : UIViewController <SessionRequestDelegate> {

	id<SignInDelegate> delegate;
	UITextField* email;
	UITextField* password;
	
}

@property (nonatomic, assign) id<SignInDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField* email;
@property (nonatomic, retain) IBOutlet UITextField* password;

-(void)attemptSignInWithEmail:(NSString*)aEmail andPassword:(NSString*)aPassword;

-(IBAction)cancelPressed;
-(IBAction)donePressed;

@end
