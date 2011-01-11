//
//  AccountViewController.h
//  Napkin
//
//  Created by Aubrey Goodman on 2/11/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLabelTextFieldViewController.h"
#import "User.h"
#import "SessionRequest.h"
#import "UserRequest.h"


@interface AccountViewController : UITableViewController <UIAlertViewDelegate, SingleLabelTextFieldDelegate, SessionRequestDelegate, UserRequestDelegate> {

	UIAlertView* signOutConfirm;
	User* user;

	NSString* editingField;
	
}

@property (nonatomic, retain) User* user;


@end
