    //
//  SiteListViewController_Phone.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 5/31/11.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SiteListViewController_Phone.h"
#import "SiteEditViewController.h"


@implementation SiteListViewController_Phone

- (void)addSite
{
	//	DoubleLabelTextFieldViewController* tNewSite = [[[DoubleLabelTextFieldViewController alloc] initWithTitle:@"New Site" label1:@"URL" label2:@"Email" caption1:@"(required)" caption2:@"(required)" text1:nil text2:nil] autorelease];
	//	tNewSite.delegate = self;
	//	[self.navigationController pushViewController:tNewSite animated:YES];
	SiteEditViewController* tCreate = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
	tCreate.site = [[[Site alloc] init] autorelease];
	tCreate.cancelBlock = ^{
		[self.navigationController popViewControllerAnimated:YES];
	};
	tCreate.doneBlock = ^(Site* aSite){
		[SiteRequest requestCreateSite:aSite delegate:self];
		[self.navigationController popViewControllerAnimated:YES];
	};
	[self.navigationController pushViewController:tCreate animated:YES];
}

#pragma mark -
#pragma mark View lifecycle

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

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	editingSite = [sites objectAtIndex:indexPath.row];
	SiteEditViewController* tSiteEdit = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
	tSiteEdit.site = editingSite;
	tSiteEdit.cancelBlock = ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
		});
	};
	tSiteEdit.doneBlock = ^(Site* aSite){
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[SiteRequest requestUpdateSite:aSite delegate:self];
		});
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
		});
	};
	[self.navigationController pushViewController:tSiteEdit animated:YES];
}

#pragma mark -

- (void)dealloc {
    [super dealloc];
}


@end
