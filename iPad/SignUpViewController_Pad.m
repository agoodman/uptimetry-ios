    //
//  SignUpViewController_Pad.m
//  VerifipMobile
//
//  Created by Aubrey Goodman on 10/27/10.
//  Copyright 2010 Migrant Studios LLC. All rights reserved.
//

#import "SignUpViewController_Pad.h"


@implementation SignUpViewController_Pad

- (id)init
{
	if( self = [super initWithNibName:@"SignUpView_Pad" bundle:[NSBundle mainBundle]] ) {
	}
	return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
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
