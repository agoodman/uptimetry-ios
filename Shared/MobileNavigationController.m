//
//  MobileNavigationController.m
//  Migrant Studios Mobile
//
//  Created by Aubrey Goodman on 1/28/10.
//  Copyright 2010 Migrant Studios LLC. All rights reserved.
//

#import "MobileNavigationController.h"


@implementation MobileNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationBar.tintColor = [UIColor colorWithRed:72.0/256.0 green:4.0/256.0 blue:112.0/256.0 alpha:1.0];
	self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	// 3.1 compatibility check
	NSString* tCurrentVersion = [[UIDevice currentDevice] systemVersion];
	if( [tCurrentVersion compare:@"3.2" options:NSNumericSearch] != NSOrderedAscending ) {
		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
