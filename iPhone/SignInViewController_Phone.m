    //
//  SignInViewController_Phone.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "SignInViewController_Phone.h"
#import "FlurryAPI.h"


@implementation SignInViewController_Phone

- (id)init
{
	if( self = [super initWithNibName:@"SignInView_Phone" bundle:[NSBundle mainBundle]] ) {
	}
	return self;
}

- (IBAction)cancelPressed
{
	[FlurryAPI logEvent:@"SignInCancel"];
	[delegate cancelSignIn];
}

- (IBAction)donePressed
{
	[FlurryAPI logEvent:@"SignInDone"];
	[self attemptSignInWithEmail:email.text andPassword:password.text];
}

@end
