    //
//  PublicViewController_Phone.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "PublicViewController_Phone.h"
#import "FlurryAPI.h"
#import "MobileNavigationController.h"
#import "SignInViewController_Phone.h"
#import "SignUpViewController_Phone.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@implementation PublicViewController_Phone

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (IBAction)signIn
{
	[FlurryAPI logEvent:@"SignIn"];
	DDLogVerbose(@"Sign In");
	
	SignInViewController_Phone* tSignIn = [[[SignInViewController_Phone alloc] initWithNibName:@"SignInView_Phone" bundle:[NSBundle mainBundle]] autorelease];
	tSignIn.delegate = self;
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSignIn] autorelease];
	[self presentModalViewController:tWrapper animated:YES];
}

- (IBAction)signUp
{
	// no parent implementation; super not required
	SignUpViewController_Phone* tSignUp = [[[SignUpViewController_Phone alloc] init] autorelease];
	
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSignUp] autorelease];
	[self presentModalViewController:tWrapper animated:YES];
}

#pragma mark -

@end
