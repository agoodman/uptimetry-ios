    //
//  SignInViewController_Pad.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "SignInViewController_Pad.h"
#import "FlurryAPI.h"


@implementation SignInViewController_Pad

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

#pragma mark -

- (id)init
{
	if( self = [super initWithNibName:@"SignInView_Pad" bundle:[NSBundle mainBundle]] ) {
	}
	return self;
}

@end
