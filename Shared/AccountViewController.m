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


@interface AccountViewController (private)
-(void)refreshUser;
@end


@implementation AccountViewController

@synthesize user;

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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if( section==0 ) {
		return 1;
	}
	if( section==2 || section==3 ) {
		return 1;
	}
	if( section==1 ) {
		return 1;
	}
    return 0;
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
//		cell.caption.text = @"";
//		cell.label.text = @"Settings";
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//	}else if( indexPath.section==3 ) {
		cell.caption.text = @"";
		cell.label.text = @"Sign Out";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if( indexPath.section==0 ) {
		if( indexPath.row==0 ) {
			SingleLabelTextFieldViewController* tName = [[[SingleLabelTextFieldViewController alloc] initWithTitle:@"Edit Name" label:@"Name" caption:nil text:[NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName]] autorelease];
			editingField = @"name";
			tName.delegate = self;
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
			tEmail.delegate = self;
			[self.navigationController pushViewController:tEmail animated:YES];											 
		}else if( indexPath.row==1 ) {
			[[[[UIAlertView alloc] initWithTitle:@"TODO" message:@"reset password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
		}
	}else if( indexPath.section==2 ) {
//		NSString* tUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerUrl"];
//		SettingsViewController* tSettings = [[SettingsViewController alloc] initWithUrl:tUrl];
//		tSettings.delegate = self;
//		[self.navigationController pushViewController:tSettings animated:YES];
//		[tSettings release];
//	}else if( indexPath.section==3 ) {
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
		return @"Session";
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
#pragma mark SingleLabelTextFieldDelegate

- (void)singleLabelTextFieldDidCancel:(SingleLabelTextFieldViewController *)controller
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)singleLabelTextField:(SingleLabelTextFieldViewController*)controller didCompleteWithText:(NSString*)text
{
	if( [editingField isEqualToString:@"name"] ) {
		NSArray* tNames = [text componentsSeparatedByString:@" "];
		user.firstName = [tNames objectAtIndex:0];
		user.lastName = [tNames objectAtIndex:1];
		[UserRequest requestUpdateUser:user delegate:self];
	}else if( [editingField isEqualToString:@"email"] ) {
		user.email = text;
		[UserRequest requestUpdateUser:user delegate:self];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

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


- (void)dealloc 
{
	[user release];
    [super dealloc];
}


@end

