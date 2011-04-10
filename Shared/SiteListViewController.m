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


static int ddLogLevel = LOG_LEVEL_ERROR;

@interface SiteListViewController (private)
-(void)refreshSites;
-(void)addSite;
-(void)showHud;
@end

@implementation SiteListViewController

@synthesize sites, hud, control;

- (void)showWhatsNext
{
	Alert(@"What's Next?",@"That's it. You're done. We will notify you by email if your site becomes unavailable.");
}

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
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];

	[self refreshSites];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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

#pragma mark -

- (void)controlSelected:(UISegmentedControl*)aControl
{
	if( aControl.selectedSegmentIndex==0 ) {
		// refresh
		[self refreshSites];
	}else{
		// add
		[self addSite];
	}
}

- (void)refreshSites
{
	[self showHud];
	[SiteRequest requestSites:self];
}

- (void)addSite
{
	DoubleLabelTextFieldViewController* tNewSite = [[[DoubleLabelTextFieldViewController alloc] initWithTitle:@"New Site" label1:@"URL" label2:@"Email" caption1:@"(required)" caption2:@"(required)" text1:nil text2:nil] autorelease];
	tNewSite.delegate = self;
	
	[self.navigationController pushViewController:tNewSite animated:YES];
}

- (IBAction)showAccount
{
	AccountViewController* tAccount = [[[AccountViewController alloc] init] autorelease];
	[self.navigationController pushViewController:tAccount animated:YES];
//	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tAccount] autorelease];
//	[self.navigationController presentModalViewController:tWrapper animated:YES]; 
}

- (void)showHud
{
	self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	hud.labelText = @"Loading";
	[self.view addSubview:hud];
	[hud show:YES];
}

- (void)hideHud
{
	[hud hide:YES];
	[hud removeFromSuperview];
	self.hud = nil;
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

	[self showHud];
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
	// do nothing;
}

- (void)siteUpdated
{
	[self hideHud];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)siteDeleted
{
	[self hideHud];
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
	DoubleLabelTextFieldViewController* tSiteEdit = [[[DoubleLabelTextFieldViewController alloc] initWithTitle:@"Edit Site" label1:@"URL" label2:@"Email" caption1:@"(required)" caption2:@"(required)" text1:editingSite.url text2:editingSite.email] autorelease];
	tSiteEdit.delegate = self;
	[self.navigationController pushViewController:tSiteEdit animated:YES];
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
    [super dealloc];
}


@end

