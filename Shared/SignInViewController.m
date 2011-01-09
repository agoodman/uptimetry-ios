    //
//  SignInViewController.m
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SignInViewController.h"
#import "Session.h"
#import "FlurryAPI.h"


@implementation SignInViewController

@synthesize delegate, email, password;

- (void)attemptSignInWithEmail:(NSString*)aEmail andPassword:(NSString*)aPassword
{
	Session* tSession = [[[Session alloc] init] autorelease];
	tSession.email = aEmail;
	tSession.password = aPassword;
	[SessionRequest requestCreateSession:tSession delegate:self];
	
//	if( [tSession createRemote] ) {
//		NSUserDefaults* tDefaults = [NSUserDefaults standardUserDefaults];
//		[tDefaults setValue:aEmail forKey:@"UserEmail"];
//		[tDefaults setValue:aPassword forKey:@"UserPassword"];
//		[tDefaults setInteger:[tSession.userId intValue] forKey:@"UserId"];
//		[tDefaults synchronize];
//		return [tSession.userId intValue];
//	}
//	return 0;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = @"Sign In";
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[FlurryAPI logEvent:@"SignIn"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[email becomeFirstResponder];
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

#pragma mark -
#pragma mark SessionRequestDelegate

- (void)sessionRequestFailed
{
	[[[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to connect to server. Please check your network connection." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
}

- (void)sessionInvalid
{
	[[[[UIAlertView alloc] initWithTitle:@"Invalid Sign In" message:@"The information you entered was not valid. Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
}

- (void)sessionCreated:(Session *)session
{
	[delegate signedInWithUserId:[session.userId intValue]];
}

#pragma mark -

- (void)dealloc 
{	
	[email release];
	[password release];
	[super dealloc];
}


@end
