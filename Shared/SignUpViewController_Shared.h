//
//  SignUpViewController_Shared.h
//  VerifipMobile
//
//  Created by Aubrey Goodman on 10/27/10.
//  Copyright 2010 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequest.h"


@interface SignUpViewController_Shared : UIViewController <UserRequestDelegate> {

	IBOutlet UITextField* firstName;
	IBOutlet UITextField* lastName;
	IBOutlet UITextField* email;
	IBOutlet UITextField* password;
	
}

@property (nonatomic, retain) UITextField* firstName;
@property (nonatomic, retain) UITextField* lastName;
@property (nonatomic, retain) UITextField* email;
@property (nonatomic, retain) UITextField* password;

@end
