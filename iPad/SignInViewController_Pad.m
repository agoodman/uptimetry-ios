    //
//  SignInViewController_Pad.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2010 VerifIP. All rights reserved.
//

#import "SignInViewController_Pad.h"
#import "FlurryAPI.h"


@implementation SignInViewController_Pad

- (id)init
{
	if( self = [super initWithNibName:@"SignInView_Pad" bundle:[NSBundle mainBundle]] ) {
	}
	return self;
}

#pragma mark -

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

	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)] autorelease];
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
