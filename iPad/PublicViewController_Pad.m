    //
//  PublicViewController_Pad.m
//  verifip
//
//  Created by Aubrey Goodman on 6/2/10.
//  Copyright 2010 VerifIP. All rights reserved.
//

#import "PublicViewController_Pad.h"
#import "SignInViewController_Pad.h"
#import "SignUpViewController_Pad.h"
#import "MobileNavigationController.h"


@implementation PublicViewController_Pad

- (IBAction)signIn
{
	SignInViewController* tSignIn = [[[SignInViewController_Pad alloc] init] autorelease];
	tSignIn.delegate = self;
	MobileNavigationController* tNav = [[[MobileNavigationController alloc] initWithRootViewController:tSignIn] autorelease];
	[self presentModalViewController:tNav animated:YES];
}

- (IBAction)signUp
{
	// no parent implementation; super not required
	SignUpViewController_Pad* tSignUp = [[[SignUpViewController_Pad alloc] init] autorelease];
	
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSignUp] autorelease];
	[self presentModalViewController:tWrapper animated:YES];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.modalPresentationStyle = UIModalPresentationFormSheet;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
