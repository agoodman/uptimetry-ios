//
//  DoubleLabelTextFieldViewController.m
//  TourWrist
//
//  Created by Aubrey Goodman on 2/1/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import "DoubleLabelTextFieldViewController.h"
#import "FlurryAPI.h"


@implementation DoubleLabelTextFieldViewController

@synthesize text1, text2, secure1, secure2, delegate;

-(id)initWithTitle:(NSString*)aTitle label1:(NSString*)aLabel1 label2:(NSString*)aLabel2 caption1:(NSString*)aCaption1 caption2:(NSString*)aCaption2 text1:(NSString*)aText1 text2:(NSString*)aText2;
{
	initLabel1 = [aLabel1 retain];
	initLabel2 = [aLabel2 retain];
	initCaption1 = [aCaption1 retain];
	initCaption2 = [aCaption2 retain];
	initText1 = [aText1 retain];
	initText2 = [aText2 retain];
	
	self.title = aTitle;
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[FlurryAPI logEvent:@"DoubleLabelText"];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)] autorelease];
	
	label1.text = initLabel1;
	label2.text = initLabel2;
	caption1.text = initCaption1;
	caption2.text = initCaption2;
	text1.text = initText1;
	text2.text = initText2;
	if( secure1 ) {
		text1.secureTextEntry = YES;
	}
	if( secure2 ) {
		text2.secureTextEntry = YES;
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)cancelPressed
{
	[FlurryAPI logEvent:@"DoubleLabelTextCancel"];
	[delegate doubleLabelTextFieldDidCancel:self];
}

- (void)donePressed
{
	[FlurryAPI logEvent:@"DoubleLabelTextDone"];
	if( [text1.text isEqualToString:@""] ) {
		[[[[UIAlertView alloc] initWithTitle:@"Required Field Missing" message:@"You must enter a name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
	}else if( [text2.text isEqualToString:@""] ) {
		[[[[UIAlertView alloc] initWithTitle:@"Required Field Missing" message:@"You must enter a URL" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
	}else{
		[delegate doubleLabelTextField:self didCompleteWithText1:text1.text text2:text2.text];
	}
}

#pragma mark -


- (void)dealloc {
	[initLabel1 release];
	[initLabel2 release];
	[initCaption1 release];
	[initCaption2 release];
	[initText1 release];
	[initText2 release];
	[label1 release];
	[label2 release];
	[caption1 release];
	[caption2 release];
	[text1 release];
	[text2 release];
    [super dealloc];
}


@end
