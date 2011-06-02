//
//  SiteListViewController_Pad.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/10/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "SiteListViewController_Pad.h"


@implementation SiteListViewController_Pad

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	visibleSlidingFramePortrait = CGRectMake(0, 844, 768, 116);
	hiddenSlidingFramePortrait = CGRectMake(0, 960, 768, 116);
	visibleTableFramePortrait = CGRectMake(0, 0, 768, 844);
	hiddenTableFramePortrait = CGRectMake(0, 0, 768, 960);
	
	visibleSlidingFrameLandscape = CGRectMake(0, 588, 1024, 116);
	hiddenSlidingFrameLandscape = CGRectMake(0, 704, 1024, 116);
	visibleTableFrameLandscape = CGRectMake(0, 0, 1024, 588);
	hiddenTableFrameLandscape = CGRectMake(0, 0, 1024, 704);	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
