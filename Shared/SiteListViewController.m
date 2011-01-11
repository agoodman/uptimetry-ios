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


static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation SiteListViewController

@synthesize sites, hud, control;

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
	self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	hud.labelText = @"Loading";
	[self.view addSubview:hud];
	[hud show:YES];
	
	[SiteRequest requestSites:self];
}

- (void)addSite
{
	Alert(@"TODO", @"show new site view");
//	SingleLabelTextFieldViewController* tNewSite = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"New Site" label:@"Title" caption:@"" text:@""] autorelease];
//	tNewSite.delegate = self;
//	
//	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tNewSite] autorelease];
//	[self.navigationController presentModalViewController:tWrapper animated:YES];
}

- (IBAction)showAccount
{
	AccountViewController* tAccount = [[[AccountViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	[self.navigationController pushViewController:tAccount animated:YES];
//	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tAccount] autorelease];
//	[self.navigationController presentModalViewController:tWrapper animated:YES]; 
}

- (void)hideHud
{
	[hud hide:YES];
	[hud removeFromSuperview];
	self.hud = nil;
}

#pragma mark -
#pragma mark SiteRequestDelegate

- (void)siteRequestFailed
{
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
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	NSMutableArray* tSites = [[[NSMutableArray alloc] initWithArray:self.sites] autorelease];
	[tSites addObject:site];
	self.sites = tSites;
	[self.tableView reloadData];
	
//	SiteEditViewController* tEdit = [[[SiteEditViewController alloc] initWithSite:site shared:NO] autorelease];
//	[self.navigationController pushViewController:tEdit animated:YES];
}	

- (void)siteFieldsInvalid:(NSArray *)errors
{
	[self hideHud];
	NSMutableString* tErrors = [[[NSMutableString alloc] init] autorelease];
	for (NSString* err in errors) {
		[tErrors appendFormat:@"%@\n",err];
	}
	Alert(@"Unable to Save", tErrors);
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
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	 */
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

