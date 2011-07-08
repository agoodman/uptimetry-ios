//
//  AccountViewController.h
//  Napkin
//
//  Created by Aubrey Goodman on 2/11/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SessionRequest.h"
#import "UserRequest.h"
#import "InventoryKit.h"


@interface AccountViewController : UITableViewController <UIAlertViewDelegate, SessionRequestDelegate, UserRequestDelegate, IKRestoreDelegate> {

	UIAlertView* signOutConfirm;
	User* user;
	NSArray* subscriptions;
	
	NSString* editingField;
	
}

@property (nonatomic, retain) User* user;
@property (retain) NSArray* subscriptions;


@end
