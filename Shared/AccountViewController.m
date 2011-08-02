//
//  AccountViewController.m
//  Napkin
//
//  Created by Aubrey Goodman on 2/11/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import "AccountViewController.h"
#import "CaptionLabelCell.h"
#import "AppDelegate_Shared.h"
#import "SingleLabelTextFieldViewController.h"
#import "SubscriptionListViewController_Shared.h"


@interface AccountViewController (private)
-(void)refreshUser;
-(void)showSubscriptionSelect;
@end


@implementation AccountViewController

@synthesize user, subscriptions;

- (id)init 
{
    if (self = [super initWithNibName:@"AccountView" bundle:[NSBundle mainBundle]]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Account";
	self.tableView.backgroundView = nil;
	self.tableView.backgroundColor = [UIColor colorWithRed:237.0/256.0 green:230.0/256.0 blue:241.0/256.0 alpha:1.0];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)] autorelease];
	
	[self refreshUser];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
//	DDLogVerbose(@"Account.viewWillAppear");
	
	[(UITableView*)self.view reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//	DDLogVerbose(@"Account.viewWillDisappear");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -

- (void)donePressed
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshUser
{
	int tUserId = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"];
	User* tUser = [[[User alloc] init] autorelease];
	tUser.userId = [NSNumber numberWithInt:tUserId];
	[UserRequest requestReadUser:tUser delegate:self];
}

- (void)signOut
{
	signOutConfirm = [[UIAlertView alloc] initWithTitle:@"Confirm Sign Out" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[signOutConfirm show];
}

- (void)showSubscriptionSelect
{
	SubscriptionListViewController_Shared* tSubs = [[[SubscriptionListViewController_Shared alloc] init] autorelease];
	tSubs.successBlock = ^(NSString* aProductIdentifier) { 
		[self.navigationController popViewControllerAnimated:YES];
	};
	tSubs.cancelBlock = ^{ [self.navigationController popViewControllerAnimated:YES]; };
	[self.navigationController pushViewController:tSubs animated:YES];
}

- (void)restoreProducts
{
	IKBasicBlock tSuccess = ^{
		async_main(^{
			Alert(@"Products Restored",@"Your products were successfully restored.");
		});
	};
	
	IKErrorBlock tFailure = ^(int aCode, NSString* aDescription) {
		async_main(^{
			Alert(@"Restore Failed",aDescription);
		});
	};
	
	[InventoryKit restoreProductsWithSuccessBlock:tSuccess
									 failureBlock:tFailure];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if( section==2 ) {
		return 2 + self.subscriptions.count;
	}
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CaptionLabelCell";
    
    CaptionLabelCell *cell = (CaptionLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
		for (id nib in nibs) {
			if( [nib isKindOfClass:[CaptionLabelCell class]] ) {
				cell = (CaptionLabelCell*)nib;
				break;
			}
		}
    }
    
	if( indexPath.section==0 ) {
		if( indexPath.row==0 ) {
			cell.caption.text = @"name";
			cell.label.text = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else if( indexPath.row==1 ) {
			cell.caption.text = @"address";
			cell.label.text = @"Enter an Address";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else{
			cell.caption.text = @"phone";
			cell.label.text = @"Enter a Phone";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}else if( indexPath.section==1 ) {
		if( indexPath.row==0 ) {
			cell.caption.text = @"email";
			cell.label.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserEmail"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else{
			cell.caption.text = @"password";
			cell.label.text = @"Reset Password";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}else if( indexPath.section==2 ) {
		if( indexPath.row==0 ) {
			cell.caption.text = @"purchase";
			cell.label.text = @"Select Subscription";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else if( indexPath.row>0 && indexPath.row-1<self.subscriptions.count ) {
			cell.caption.text = @"active";
			cell.label.text = [self.subscriptions objectAtIndex:indexPath.row-1];
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}else{
			cell.caption.text = @"reset";
			cell.label.text = @"Restore Purchases";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if( indexPath.section==0 ) {
		if( indexPath.row==0 ) {
			SingleLabelTextFieldViewController* tName = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit Name" label:@"Name" caption:nil text:[NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName]] autorelease];
			editingField = @"name";
			tName.cancelBlock = ^{
				[self.navigationController popViewControllerAnimated:YES];
			};
			tName.doneBlock = ^(NSString* aString){
				NSArray* tNames = [aString componentsSeparatedByString:@" "];
				user.firstName = [tNames objectAtIndex:0];
				user.lastName = [tNames objectAtIndex:1];
				[UserRequest requestUpdateUser:user delegate:self];
				[self.navigationController popViewControllerAnimated:YES];
			};
			[self.navigationController pushViewController:tName animated:YES];											 
		}else if( indexPath.row==1 ) {
			[[[[UIAlertView alloc] initWithTitle:@"TODO" message:@"edit address" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
		}else if( indexPath.row==2 ) {
			[[[[UIAlertView alloc] initWithTitle:@"TODO" message:@"edit phone" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
		}
	}else if( indexPath.section==1 ) {
		if( indexPath.row==0 ) {
			SingleLabelTextFieldViewController* tEmail = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit Email" label:@"Email" caption:nil text:user.email] autorelease];
			editingField = @"email";
			tEmail.cancelBlock = ^{
				[self.navigationController popViewControllerAnimated:YES];
			};
			tEmail.doneBlock = ^(NSString* aString){
				user.email = aString;
				[UserRequest requestUpdateUser:user delegate:self];
				[self.navigationController popViewControllerAnimated:YES];
			};
			[self.navigationController pushViewController:tEmail animated:YES];											 
		}else if( indexPath.row==1 ) {
			[[[[UIAlertView alloc] initWithTitle:@"TODO" message:@"reset password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
		}
	}else if( indexPath.section==2 ) {
		if( indexPath.row==0 ) {
			[self showSubscriptionSelect];
		}else if( indexPath.row>0 && indexPath.row-1<self.subscriptions.count ) {
			
		}else{
			[self restoreProducts];
		}
	}
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
//	static NSArray* sSectionTitles;
//	if( sSectionTitles==nil ) {
//		sSectionTitles = [NSArray arrayWithObjects:@"Personal Information",@"Portfolios",nil];
//	}
//	return [sSectionTitles objectAtIndex:section];
	if( section==0 ) {
		return @"Personal Information";
	}else if( section==1 ) {
		return @"Account Information";
	}else{
		return @"Subscription";
	}
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( [alertView isEqual:signOutConfirm] ) {
		if( buttonIndex==1 ) {
			[SessionRequest requestDeleteSession:self];
			[signOutConfirm release];
		}
	}
	[(UITableView*)self.view reloadData];
}

#pragma mark -
#pragma mark SessionRequestDelegate

- (void)sessionDeleted
{
	[(AppDelegate_Shared*)[[UIApplication sharedApplication] delegate] didSignOut];
}

- (void)sessionRequestFailed
{
	[[[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to connect to server. Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
}

#pragma mark -
#pragma mark UserRequestDelegate

- (void)userReceived:(User*)aUser
{
	if( aUser==nil ) {
		[self userRequestFailed];
	}else{
		self.user = aUser;
		NSDictionary* tDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IKSubscriptionProducts" ofType:@"plist"]];
		NSMutableArray* tSubscriptions = [NSMutableArray array];
		for (NSString* productId in [tDict allKeys]) {
			if( [InventoryKit productActivated:productId] ) {
				NSDictionary* tSub = [tDict objectForKey:productId];
				[tSubscriptions addObject:[tSub objectForKey:@"title"]];
			}
		}
		self.subscriptions = tSubscriptions;
		[self.tableView reloadData];
	}
}

- (void)userUpdated
{
}

- (void)userFieldsInvalid:(NSArray *)errors
{
	
}

- (void)userRequestFailed
{
	[self sessionDeleted];
}

#pragma mark -
#pragma mark IKRestoreDelegate

- (void)productRestoreFailed:(NSError *)error
{
	Alert(@"Restore Failed",@"Unable to restore products");
}

- (void)productsRestored
{
	Alert(@"Products Restored",@"Your products were successfully restored.");
}

#pragma mark -


- (void)dealloc 
{
	[user release];
    [super dealloc];
}


@end

