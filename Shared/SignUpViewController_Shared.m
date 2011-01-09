//
//  SignUpViewController_Shared.m
//  VerifipMobile
//
//  Created by Aubrey Goodman on 10/27/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import "SignUpViewController_Shared.h"
#import "FlurryAPI.h"


@implementation SignUpViewController_Shared

@synthesize firstName, lastName, email, password;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = @"Sign Up";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)] autorelease];
	[FlurryAPI logEvent:@"SignUp"];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[firstName becomeFirstResponder];
}

- (void)cancelPressed
{
	[FlurryAPI logEvent:@"SignUpCancel"];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)donePressed
{
	[FlurryAPI logEvent:@"SignUpDone"];
//	[[[[UIAlertView alloc] initWithTitle:@"TODO" message:@"process sign up" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
	
	User* tUser = [[[User alloc] init] autorelease];
	tUser.firstName = firstName.text;
	tUser.lastName = lastName.text;
	tUser.email = email.text;
	tUser.password = password.text;
	tUser.termsOfServiceAccepted = YES;
	tUser.emailConfirmed = YES;
	
	[UserRequest requestCreateUser:tUser delegate:self];
}

#pragma mark -
#pragma mark UserRequestDelegate

- (void)userCreated:(User *)user
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	Alert(@"User created",@"Please sign in");
}

- (void)userFieldsInvalid:(NSArray*)errors
{
	NSMutableString* tError = [[[NSMutableString alloc] init] autorelease];
	for (NSString* error in errors) {
		[tError appendFormat:@"%@\n",error];
	}
	Alert(@"Unable to save",tError);
}

- (void)userRequestFailed
{
	NetworkAlert;
}

#pragma mark -

- (void)dealloc
{
	[firstName release];
	[lastName release];
	[email release];
	
	[super dealloc];
}

@end
