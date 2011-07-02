//
//  SubscriptionListViewController_Shared.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/29/11.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import "SubscriptionListViewController_Shared.h"
#import "UIActionSheet+BlocksKit.h"
#import "UIBarButtonItem+BlocksKit.h"


static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation SubscriptionListViewController_Shared

@synthesize subscriptions, successBlock, cancelBlock, hud;

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
	
	self.navigationItem.title = @"Select Plan";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
		cancelBlock();
	}] autorelease];

	self.hud = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"Connecting to iTunes";
	[hud show:YES];
	
	NSDictionary* tSubscriptionProducts = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IKSubscriptionProducts" ofType:@"plist"]];
	NSSet* tProductIds = [NSSet setWithArray:[tSubscriptionProducts allKeys]];
	SKProductsRequest* tRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:tProductIds];
	tRequest.delegate = self;
	[tRequest start];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return subscriptions.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary* tSubscription = [subscriptions objectAtIndex:indexPath.row];
	cell.textLabel.text = [tSubscription objectForKey:@"title"];
	cell.detailTextLabel.text = [tSubscription objectForKey:@"description"];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary* tSubscription = [subscriptions objectAtIndex:indexPath.row];
	UIActionSheet* tAction = [[[UIActionSheet alloc] initWithTitle:[tSubscription objectForKey:@"description"]] autorelease];
	[tAction addButtonWithTitle:@"Select Plan" handler:^{
		[InventoryKit purchaseProduct:[tSubscription objectForKey:@"identifier"] delegate:self];
	}];
	[tAction setCancelButtonWithTitle:@"Cancel" handler:^{}];
	[tAction showInView:self.navigationController.view];
	
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	if( response.invalidProductIdentifiers.count>0 ) {
		DDLogVerbose(@"invalid products: %@",response.invalidProductIdentifiers);
	}
	
	NSMutableArray* tSubscriptions = [NSMutableArray array];
	for (SKProduct* tProduct in response.products) {
		DDLogVerbose(@"productId: %@, title: %@, description: %@, price: %@",tProduct.productIdentifier,tProduct.localizedTitle,tProduct.localizedDescription,tProduct.price);
		NSDictionary* tSubscription = [NSDictionary dictionaryWithObjectsAndKeys:tProduct.productIdentifier,@"identifier",tProduct.localizedTitle,@"title",tProduct.localizedDescription,@"description",tProduct.price,@"price",nil];
		[tSubscriptions addObject:tSubscription];
	}
	
	// sort subscriptions by price
	self.subscriptions = [tSubscriptions sortedArrayUsingComparator:^(id a, id b) {
		NSNumber* aPrice = [(NSDictionary*)a objectForKey:@"price"];
		NSNumber* bPrice = [(NSDictionary*)b objectForKey:@"price"];
		return [aPrice compare:bPrice];
	}];

	dispatch_async(dispatch_get_main_queue(), ^{
		[hud hide:YES];
		[self.tableView reloadData];
	});
		
	[request autorelease];
}

#pragma mark -
#pragma mark IKPurchaseDelegate

- (void)purchaseDidStartForProductWithKey:(NSString *)productKey
{
	hud.labelText = @"Purchasing";
	[hud show:YES];
}

- (void)purchaseDidCompleteForProductWithKey:(NSString *)productKey
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[hud hide:YES];
		successBlock(productKey);
	});
}

- (void)purchaseDidFailForProductWithKey:(NSString *)productKey
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[hud hide:YES];
		Alert(@"Purchase Failed",@"Unable to complete your purchase");
	});
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


- (void)dealloc 
{
	[subscriptions release];
	[hud release];
    [super dealloc];
}


@end

