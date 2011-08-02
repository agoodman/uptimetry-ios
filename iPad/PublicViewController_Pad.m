    //
//  PublicViewController_Pad.m
//  verifip
//
//  Created by Aubrey Goodman on 6/2/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "PublicViewController_Pad.h"
#import "SignInViewController_Pad.h"
#import "SignUpViewController_Pad.h"
#import "MobileNavigationController.h"


static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation PublicViewController_Pad

- (IBAction)signIn
{
	SignInViewController_Pad* tSignIn = [[[SignInViewController_Pad alloc] init] autorelease];
	tSignIn.delegate = self;
	MobileNavigationController* tNav = [[[MobileNavigationController alloc] initWithRootViewController:tSignIn] autorelease];
	[self presentModalViewController:tNav animated:YES];
}

- (IBAction)signUp
{
	// no parent implementation; super not required
	SignUpViewController_Pad* tSignUp = [[[SignUpViewController_Pad alloc] init] autorelease];
	tSignUp.successBlock = ^(User* aUser) {
		async_main(^{
			[self dismissModalViewControllerAnimated:YES];
			Alert(@"Account Created",@"Sign in to get started");
		});
	};
	tSignUp.failureBlock = ^{
		async_main(^{
			[self dismissModalViewControllerAnimated:YES];
		});
	};
	
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSignUp] autorelease];
	[self presentModalViewController:tWrapper animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


@end
