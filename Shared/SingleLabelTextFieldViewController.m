//
//  SingleLabelTextFieldViewController.m
//  TourWrist
//
//  Created by Aubrey Goodman on 2/1/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import "SingleLabelTextFieldViewController.h"
#import "FlurryAPI.h"


@implementation SingleLabelTextFieldViewController

@synthesize label, caption, textField, delegate;

-(id)initWithTitle:(NSString*)aTitle label:(NSString*)aLabel caption:(NSString*)aCaption text:(NSString*)aText
{
	if( self = [super initWithNibName:@"SingleLabelTextFieldView" bundle:[NSBundle mainBundle]] ) {
		_label = [aLabel isEqual:[NSNull null]] ? nil : [aLabel retain];
		_caption = [aCaption isEqual:[NSNull null]] ? nil :[aCaption retain];
		_textField = [aText isEqual:[NSNull null]] ? nil :[aText retain];
	}
	self.title = aTitle;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(donePressed)] autorelease];
	[FlurryAPI logEvent:@"SingleLabelText"];
	
	label.text = _label;
	caption.text = _caption;
	textField.text = _textField;
	
	[_label release];
	[_caption release];
	[_textField release];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[textField becomeFirstResponder];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)cancelPressed
{
	[FlurryAPI logEvent:@"SingleLabelTextCancel"];
	[textField resignFirstResponder];
	[delegate singleLabelTextFieldDidCancel:self];
}

- (void)donePressed
{
	[FlurryAPI logEvent:@"SingleLabelTextDone"];
	[textField resignFirstResponder];
	[delegate singleLabelTextField:self didCompleteWithText:textField.text];
}

#pragma mark -


- (void)dealloc {
	[label release];
	[textField release];
	[caption release];
    [super dealloc];
}


@end
