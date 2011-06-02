    //
//  SiteListViewController_Phone.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 5/31/11.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SiteListViewController_Phone.h"


@implementation SiteListViewController_Phone

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

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	visibleSlidingFramePortrait = CGRectMake(0, 316, 320, 100);
	hiddenSlidingFramePortrait = CGRectMake(0, 416, 320, 100);
	visibleTableFramePortrait = CGRectMake(0, 0, 320, 316);
	hiddenTableFramePortrait = CGRectMake(0, 0, 320, 416);
	
	visibleSlidingFrameLandscape = CGRectMake(0, 186, 480, 82);
	hiddenSlidingFrameLandscape = CGRectMake(0, 268, 480, 82);
	visibleTableFrameLandscape = CGRectMake(0, 0, 480, 186);
	hiddenTableFrameLandscape = CGRectMake(0, 0, 480, 268);	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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
