//
//  SiteListViewController.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "SiteListViewController.h"
#import "AppDelegate_Shared.h"
#import "AccountViewController.h"
#import "SiteEditViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "SubscriptionListViewController_Shared.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@interface SiteListViewController (private)
-(void)refreshSites;
-(void)addSite;
-(void)showHud:(NSString*)aLabel;
@end

@implementation SiteListViewController

@synthesize sites, tableView, slidingView, control;

- (void)showWhatsNext
{
	Alert(@"What's Next?",@"That's it. You're done. We will notify you by email if your site becomes unavailable.");
}

//- (IBAction)showUpgrade
//{
//	if( [SKPaymentQueue canMakePayments] ) {
//		SKProductsRequest* tRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductDisableAd]];
//		tRequest.delegate = self;
//		[self showHud:@"Connecting to iTunes"];
//		[tRequest start];
//	}else{
//		Alert(@"Service Unavailable",@"Please try again later");
//	}
//}

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStylePlain target:self action:@selector(showAccount)] autorelease];	
	
	NSArray* tButtons = [NSArray arrayWithObjects:
						 [UIImage imageNamed:@"Refresh.png"],
						 [UIImage imageNamed:@"Add.png"],
						 nil];
	self.control = [[[UISegmentedControl alloc] initWithItems:tButtons] autorelease];
	control.segmentedControlStyle = UISegmentedControlStyleBar;
	control.momentary = YES;
	[control addTarget:self action:@selector(controlSelected:) forControlEvents:UIControlEventAllEvents];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:control] autorelease];
	
	// disable ad if user has paid
	if( [InventoryKit productActivated:kProductDisableAd] ) {
		DDLogVerbose(@"Disabling ad");
		banner.delegate = nil;
		[banner cancelBannerViewAction];
	}
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];

	DDLogVerbose(@"SiteList.viewWillAppear");
	[self refreshSites];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ) {
		banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	}else{
		banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	}
}

#pragma mark -

- (void)controlSelected:(UISegmentedControl*)aControl
{
	if( aControl.selectedSegmentIndex==0 ) {
		// force refresh
		self.sites = nil;
		[self refreshSites];
	}else{
		// add
		[self addSite];
	}
}

- (void)refreshSites
{
	if( self.sites==nil ) {
		[self showHud:@"Loading"];
		[SiteRequest requestSites:self];
	}
}

- (void)addSite
{
	SiteEditViewController* tCreate = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tCreate] autorelease];
	tCreate.site = [[[Site alloc] init] autorelease];
	tCreate.cancelBlock = ^{
		[self.navigationController dismissModalViewControllerAnimated:YES];
	};
	tCreate.doneBlock = ^(Site* aSite){
		SiteBlock tSuccess = ^(Site* aSite) {
			NSMutableArray* tSites = [NSMutableArray arrayWithArray:self.sites];
			[tSites addObject:aSite];
			self.sites = tSites;
			
			[self.navigationController dismissModalViewControllerAnimated:YES];
			[self.tableView reloadData];
		};
		
		SiteErrorBlock tFailure = ^(int aStatusCode, NSArray* aErrors) {
			if( aStatusCode==402 ) {
				UIAlertView* tAlert = [[[UIAlertView alloc] initWithTitle:@"Subscription Upgrade Required" message:@"You must upgrade your subscription before you can add a site"] autorelease];
				[tAlert addButtonWithTitle:@"Upgrade" handler:^{
					SubscriptionListViewController_Shared* tSubs = [[[SubscriptionListViewController_Shared alloc] init] autorelease];
					tSubs.successBlock = ^(NSString* aProductIdentifier) { 
						async_main(^{
							[tWrapper popViewControllerAnimated:YES]; 
						});
					};
					tSubs.cancelBlock = ^{
						async_main(^{
							[tWrapper popViewControllerAnimated:YES]; 
						});
					};
					[tWrapper pushViewController:tSubs animated:YES];
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
	[self.navigationController presentModalViewController:tWrapper animated:YES];
}

- (IBAction)showAccount
{
	AccountViewController* tAccount = [[[AccountViewController alloc] init] autorelease];
	[self.navigationController pushViewController:tAccount animated:YES];
//	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tAccount] autorelease];
//	[self.navigationController presentModalViewController:tWrapper animated:YES]; 
}

#pragma mark -
#pragma mark DoubleLabelTextFieldDelegate

- (void)doubleLabelTextFieldDidCancel:(DoubleLabelTextFieldViewController *)src
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)doubleLabelTextField:(DoubleLabelTextFieldViewController *)src didCompleteWithText1:(NSString *)text1 text2:(NSString *)text2
{
	int tUserId = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"];

	Site* tSite = [[[Site alloc] init] autorelease];
	tSite.userId = [NSNumber numberWithInt:tUserId];
	tSite.url = text1;
	tSite.email = text2;

	[self showHud:@"Saving"];
	if( editingSite ) {
		tSite.siteId = editingSite.siteId;
		[SiteRequest requestUpdateSite:tSite delegate:self];
	}else{
		[SiteRequest requestCreateSite:tSite delegate:self];
	}
}

#pragma mark -
#pragma mark SiteRequestDelegate

- (void)siteRequestFailed
{
	editingSite = nil;
	[self hideHud];
	NetworkAlert;
}

- (void)sitesReceived:(NSArray *)aSites
{
	[self hideHud];
	self.sites = aSites;
	
	[self.tableView reloadData];
}

- (void)siteReceived:(Site*)site
{
	[self hideHud];
	[self.navigationController popViewControllerAnimated:YES];
	
	NSMutableArray* tSites = [[[NSMutableArray alloc] initWithArray:self.sites] autorelease];
	[tSites addObject:site];
	self.sites = tSites;
	[self.tableView reloadData];
	
	[self showWhatsNext];
}	

- (void)siteCreated:(Site*)site
{
	[self refreshSites];
	// do nothing;
}

- (void)siteUpdated
{
	[self hideHud];
//	[self.navigationController popViewControllerAnimated:YES];
}

- (void)siteDeleted
{
	[self hideHud];
	self.sites = nil;
	[self refreshSites];
}

- (void)siteFieldsInvalid:(NSArray *)errors
{
	[self hideHud];
	NSMutableString* tErrors = [[[NSMutableString alloc] init] autorelease];
	for (NSString* err in errors) {
		[tErrors appendFormat:@"%@\n",err];
	}
	DDLogVerbose(tErrors);
	Alert(@"Unable to Save", tErrors);
}

- (void)siteUnauthorized
{
	[self hideHud];
	AppDelegate_Shared* tAppDelegate = (AppDelegate_Shared*)[[UIApplication sharedApplication] delegate];
	[tAppDelegate didSignOut];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sites.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Site* tSite = [sites objectAtIndex:indexPath.row];
	cell.textLabel.text = tSite.url;
	cell.detailTextLabel.text = tSite.email;
	int tDownCount = -1;
	if( tSite.downCount && ![tSite.downCount isEqual:[NSNull null]] ) {
		tDownCount = [tSite.downCount intValue];
	}
	if( tDownCount==0 ) {
		cell.imageView.image = [UIImage imageNamed:@"indicator-ok.png"];
	}else if( tDownCount==1 ) {
		cell.imageView.image = [UIImage imageNamed:@"indicator-notice.png"];
	}else{
		cell.imageView.image = [UIImage imageNamed:@"indicator-alert.png"];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		Site* tSite = [sites objectAtIndex:indexPath.row];
		[SiteRequest requestDeleteSite:tSite delegate:self];
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	editingSite = [sites objectAtIndex:indexPath.row];
	SiteEditViewController* tSiteEdit = [[[SiteEditViewController alloc] initWithNibName:@"SiteEditView" bundle:[NSBundle mainBundle]] autorelease];
	tSiteEdit.site = editingSite;
	tSiteEdit.cancelBlock = ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.navigationController dismissModalViewControllerAnimated:YES];
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		});
	};
	tSiteEdit.doneBlock = ^(Site* aSite){
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[SiteRequest requestUpdateSite:aSite delegate:self];
		});
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.navigationController dismissModalViewControllerAnimated:YES];
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		});
	};
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSiteEdit] autorelease];
	[self.navigationController presentModalViewController:tWrapper animated:YES];
}

#pragma mark -
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)aBanner
{
	if( !bannerVisible ) {
		DDLogVerbose(@"ShowBanner");
		BOOL tOrientationPortrait = self.view.frame.size.height > self.view.frame.size.width;
		// animate sliding view to show banner
		CGRect tSlidingViewFrame = tOrientationPortrait ? visibleSlidingFramePortrait : visibleSlidingFrameLandscape;
		CGRect tTableViewFrame = tOrientationPortrait ? visibleTableFramePortrait : visibleTableFrameLandscape;
		DDLogVerbose(@"slidingView -> (%d,%d,%d,%d)",(int)tSlidingViewFrame.origin.x,(int)tSlidingViewFrame.origin.y,(int)tSlidingViewFrame.size.width,(int)tSlidingViewFrame.size.height);
		DDLogVerbose(@"tableView -> (%d,%d,%d,%d)",(int)tTableViewFrame.origin.x,(int)tTableViewFrame.origin.y,(int)tTableViewFrame.size.width,(int)tTableViewFrame.size.height);
		[UIView beginAnimations:@"ShowBanner" context:nil];
		slidingView.frame = tSlidingViewFrame;
		tableView.frame = tTableViewFrame;
		[UIView commitAnimations];
		
		bannerVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)aBanner didFailToReceiveAdWithError:(NSError *)error
{
	if( bannerVisible ) {
		DDLogVerbose(@"HideBanner");
		BOOL tOrientationPortrait = self.view.frame.size.height > self.view.frame.size.width;
		// animate sliding view to hide banner
		CGRect tSlidingViewFrame = tOrientationPortrait ? hiddenSlidingFramePortrait : hiddenSlidingFrameLandscape;
		CGRect tTableViewFrame = tOrientationPortrait ? hiddenTableFramePortrait : hiddenTableFrameLandscape;
		DDLogVerbose(@"slidingView -> (%d,%d,%d,%d)",(int)tSlidingViewFrame.origin.x,(int)tSlidingViewFrame.origin.y,(int)tSlidingViewFrame.size.width,(int)tSlidingViewFrame.size.height);
		DDLogVerbose(@"tableView -> (%d,%d,%d,%d)",(int)tTableViewFrame.origin.x,(int)tTableViewFrame.origin.y,(int)tTableViewFrame.size.width,(int)tTableViewFrame.size.height);
		[UIView beginAnimations:@"HideBanner" context:nil];
		slidingView.frame = tSlidingViewFrame;
		tableView.frame = tTableViewFrame;
		[UIView commitAnimations];
		
		bannerVisible = NO;
	}
}

#pragma mark -
#pragma mark IKPurchaseDelegate

- (void)purchaseDidStartForProductWithKey:(NSString *)productKey
{
	DDLogVerbose(@"purchase did start for product: %@",productKey);
}

- (void)purchaseDidCompleteForProductWithKey:(NSString*)productKey
{
	DDLogVerbose(@"purchase did complete for product: %@",productKey);
	[self bannerView:banner didFailToReceiveAdWithError:nil];
}

- (void)purchaseDidFailForProductWithKey:(NSString *)productKey
{
	DDLogVerbose(@"purchase did fail for product: %@",productKey);
}

//#pragma mark -
//#pragma mark SKProductRequestDelegate
//
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//	[self hideHud];
//	DDLogVerbose(@"product response received");
//	DDLogVerbose(@"\tinvalid product ids: %@",response.invalidProductIdentifiers);
//	DDLogVerbose(@"\tvalid products: %@",response.products);
//	if( [response.products containsObject:kProductDisableAd] ) {
//		SKProduct* tProduct = [response.products objectAtIndex:0];
//		UIActionSheet* tAction = [[[UIActionSheet alloc] initWithTitle:tProduct.localizedDescription delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:tProduct.localizedTitle,nil] autorelease];
//		[tAction showInView:self.view];
//	}else if( [response.invalidProductIdentifiers containsObject:kProductDisableAd] ) {
//		Alert(@"Product Unavailable",@"Please try again later.");
//	}else{
//		Alert(@"Oops!",@"The app encountered an unknown error.");
//	}
//	[request autorelease];
//}
//
#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	// do nothing
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( buttonIndex==0 ) {
		[InventoryKit purchaseProduct:kProductDisableAd delegate:self];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[sites release];
	banner.delegate = nil;
	[banner release];
	[tableView release];
	[slidingView release];
    [super dealloc];
}


@end

