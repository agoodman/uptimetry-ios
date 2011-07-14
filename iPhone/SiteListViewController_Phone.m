    //
//  SiteListViewController_Phone.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 5/31/11.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SiteListViewController_Phone.h"
#import "SiteEditViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "SubscriptionListViewController_Shared.h"


@implementation SiteListViewController_Phone

- (void)addSite
{
	SiteEditViewController* tCreate = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
	tCreate.site = [[[Site alloc] init] autorelease];
	tCreate.cancelBlock = ^{
		[self.navigationController popViewControllerAnimated:YES];
	};
	tCreate.doneBlock = ^(Site* aSite){
		SiteBlock tSuccess = ^(Site* aSite) {
			NSMutableArray* tSites = [NSMutableArray arrayWithArray:self.sites];
			[tSites addObject:aSite];
			self.sites = tSites;
			
			[self.navigationController popViewControllerAnimated:YES];
			[self.tableView reloadData];
		};
		
		SiteErrorBlock tFailure = ^(int aStatusCode, NSArray* aErrors) {
			if( aStatusCode==402 ) {
				UIAlertView* tAlert = [UIAlertView alertWithTitle:@"Subscription Upgrade Required" message:@"You must upgrade your subscription before you can add a site"];
				[tAlert addButtonWithTitle:@"Upgrade" handler:^{
					SubscriptionListViewController_Shared* tSubs = [[[SubscriptionListViewController_Shared alloc] init] autorelease];
					tSubs.successBlock = ^(NSString* aProductIdentifier) { 
						[self.navigationController popViewControllerAnimated:YES]; 
					};
					tSubs.cancelBlock = ^{ [self.navigationController popViewControllerAnimated:YES]; };
					[self.navigationController pushViewController:tSubs animated:YES];
				}];
				[tAlert setCancelButtonWithTitle:@"Cancel" handler:^{}];
				[tAlert show];
			}else if( aStatusCode==422 ) {
				NSMutableString* tMsg = [NSMutableString string];
				for (NSString* tError in aErrors) {
					[tMsg appendFormat:@"%@\n",tError];
				}
				Alert(@"Invalid Fields",tMsg);
			}else{
				NetworkAlert;
			}
		};

		[SiteRequest requestCreateSite:aSite success:tSuccess failure:tFailure];
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
