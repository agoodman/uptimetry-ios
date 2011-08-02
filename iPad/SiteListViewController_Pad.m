//
//  SiteListViewController_Pad.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/10/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "SiteListViewController_Pad.h"
#import "MobileNavigationController.h"
#import "SiteEditViewController.h"
#import "AccountViewController_Pad.h"


@implementation SiteListViewController_Pad

- (void)showAccount
{
	AccountViewController_Pad* tAccount = [[[AccountViewController_Pad alloc] init] autorelease];
	[self.navigationController pushViewController:tAccount animated:YES];	
}

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


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//	editingSite = [sites objectAtIndex:indexPath.row];
//	SiteEditViewController* tSiteEdit = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
//	tSiteEdit.site = editingSite;
////	DoubleLabelTextFieldViewController* tSiteEdit = [[[DoubleLabelTextFieldViewController alloc] initWithTitle:@"Edit Site" label1:@"URL" label2:@"Email" caption1:@"(required)" caption2:@"(required)" text1:editingSite.url text2:editingSite.email] autorelease];
////	tSiteEdit.delegate = self;
//	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSiteEdit] autorelease];
//	[self.navigationController presentModalViewController:tWrapper animated:YES];
//}


@end
