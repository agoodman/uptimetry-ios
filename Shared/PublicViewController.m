    //
//  PublicViewController.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "PublicViewController.h"
#import "AppDelegate_Shared.h"
#import "FlurryAPI.h"
#import "MobileNavigationController.h"


static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation PublicViewController

#pragma mark IBActions

- (IBAction)signIn
{
}

- (IBAction)signUp
{
	[FlurryAPI logEvent:@"SignUp"];
	DDLogVerbose(@"Sign Up");
}

#pragma mark -
#pragma mark SignInDelegate

- (void)cancelSignIn
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)signedInWithUserId:(int)userId
{
	[self dismissModalViewControllerAnimated:YES];
	
	AppDelegate_Shared* tAppDelegate = (AppDelegate_Shared*)[[UIApplication sharedApplication] delegate];
	[tAppDelegate signedInWithUserId:userId];
}

#pragma mark -

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


@end
