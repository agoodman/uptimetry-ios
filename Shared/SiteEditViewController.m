//
//  SiteEditViewController.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/2/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "SiteEditViewController.h"
#import "SingleLabelTextFieldViewController.h"
#import "InventoryKit.h"
#import "UIViewController+InventoryKit.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@implementation SiteEditViewController

@synthesize tableView, site, cancelBlock, doneBlock;

#pragma mark -

- (void)cancelPressed
{
	cancelBlock();
}

- (void)donePressed
{
	if( !site.url ) {
		Alert(@"Required Field Missing",@"You must enter a URL");
	}else if( !site.email ) {
		Alert(@"Required Field Missing",@"You must enter an email");
	}else{
		doneBlock(site);
	}
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	if( site.url && site.email ) {
		self.navigationItem.title = @"Edit Site";
	}else{
		self.navigationItem.title = @"Add Site";
	}
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if( section==0 || section==1 ) {
		return 1;
	}else if( section==2 ) {
		return 1;
	}
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if( section==0 ) {
		return @"URL";
	}else if( section==1 ) {
		return @"Email";
	}else if( section==2 ) {
		if( [InventoryKit productActivated:kProductDisableAd] ) {
			if( site.cssSelector && ![site.cssSelector isEqual:[NSNull null]] ) {
				return @"Content Matcher (CSS Selector)";
			}else if( site.xpath && ![site.xpath isEqual:[NSNull null]] ) {
				return @"Content Matcher (XPath)";
			}else{
				return @"Content Matcher";
			}
		}else{
			return @"Content Matcher";
		}
	}
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if( indexPath.section==0 ) {
		if( site.url ) {
			cell.textLabel.text = site.url;
		}else{
			cell.textLabel.text = @"Enter a URL";
		}
	}else if( indexPath.section==1 ) {
		if( site.email ) {
			cell.textLabel.text = site.email;
		}else{
			cell.textLabel.text = @"Enter an email";
		}
	}else if( indexPath.section==2 ) {
		if( [InventoryKit productActivated:kProductDisableAd] ) {
			if( site.cssSelector && ![site.cssSelector isEqual:[NSNull null]] ) {
				cell.textLabel.text = site.cssSelector;
			}else if( site.xpath && ![site.xpath isEqual:[NSNull null]] ) {
				cell.textLabel.text = site.xpath;
			}else{
				cell.textLabel.text = @"Add Content Matcher";
			}
		}else{
			cell.textLabel.text = @"Upgrade to Add Content Matcher";
		}
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if( indexPath.section==0 ) {
		SingleLabelTextFieldViewController* tUrl = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit URL" label:@"URL" caption:@"required" text:site.url] autorelease];
		tUrl.cancelBlock = ^{
			[self.navigationController popViewControllerAnimated:YES];
		};
		tUrl.doneBlock = ^(NSString* aString){
			site.url = aString;
			[self.navigationController popViewControllerAnimated:YES];
		};
		[self.navigationController pushViewController:tUrl animated:YES];
	}else if( indexPath.section==1 ) {
		SingleLabelTextFieldViewController* tEmail = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit Email" label:@"Email" caption:@"required" text:site.email] autorelease];
		tEmail.cancelBlock = ^{
			[self.navigationController popViewControllerAnimated:YES];
		};
		tEmail.doneBlock = ^(NSString* aString){
			site.email = aString;
			[self.navigationController popViewControllerAnimated:YES];
		};
		[self.navigationController pushViewController:tEmail animated:YES];
		
	}else if( indexPath.section==2 ) {
		if( [InventoryKit productActivated:kProductDisableAd] ) {
			if( site.cssSelector && ![site.cssSelector isEqual:[NSNull null]] ) {
				SingleLabelTextFieldViewController* tCss = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit CSS Selector" label:@"CSS Selector" caption:@"optional" text:site.cssSelector] autorelease];
				tCss.cancelBlock = ^{
					[self.navigationController popViewControllerAnimated:YES];
				};
				tCss.doneBlock = ^(NSString* aString){
					site.cssSelector = aString;
					[self.navigationController popViewControllerAnimated:YES];
				};
				[self.navigationController pushViewController:tCss animated:YES];
			}else if( site.xpath && ![site.xpath isEqual:[NSNull null]] ) {
				SingleLabelTextFieldViewController* tXpath = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit XPath" label:@"XPath" caption:@"optional" text:site.xpath] autorelease];
				tXpath.cancelBlock = ^{
					[self.navigationController popViewControllerAnimated:YES];
				};
				tXpath.doneBlock = ^(NSString* aString){
					site.xpath = aString;
					[self.navigationController popViewControllerAnimated:YES];
				};
				[self.navigationController pushViewController:tXpath animated:YES];
			}else{
				UIActionSheet* tAction = [[[UIActionSheet alloc] initWithTitle:@"Select a type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"CSS Selector",@"XPath",nil] autorelease];
				[tAction showInView:self.view];
			}
		}else{
			[self showUpgrade];
		}
	}
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( [InventoryKit productActivated:kProductDisableAd] ) {
		if( buttonIndex==0 ) {
			SingleLabelTextFieldViewController* tCss = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit CSS Selector" label:@"CSS Selector" caption:@"optional" text:site.cssSelector] autorelease];
			tCss.cancelBlock = ^{
				[self.navigationController popViewControllerAnimated:YES];
			};
			tCss.doneBlock = ^(NSString* aString){
				site.cssSelector = aString;
				[self.navigationController popViewControllerAnimated:YES];
			};
			[self.navigationController pushViewController:tCss animated:YES];
			
		}else if( buttonIndex==1 ) {
			SingleLabelTextFieldViewController* tXpath = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit XPath" label:@"XPath" caption:@"optional" text:site.xpath] autorelease];
			tXpath.cancelBlock = ^{
				[self.navigationController popViewControllerAnimated:YES];
			};
			tXpath.doneBlock = ^(NSString* aString){
				site.xpath = aString;
				[self.navigationController popViewControllerAnimated:YES];
			};
			[self.navigationController pushViewController:tXpath animated:YES];
			
		}else{
			// do nothing
		}
	}else{
		if( buttonIndex==0 ) {
			[InventoryKit purchaseProduct:kProductDisableAd delegate:self];
		}
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
	[self.tableView reloadData];
}

- (void)purchaseDidFailForProductWithKey:(NSString *)productKey
{
	DDLogVerbose(@"purchase did fail for product: %@",productKey);
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
	[tableView release];
	[site release];
    [super dealloc];
}


@end

