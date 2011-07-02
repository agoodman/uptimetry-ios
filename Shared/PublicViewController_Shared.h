//
//  PublicViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController_Shared.h"


@interface PublicViewController_Shared : UIViewController <SignInDelegate> {

	IBOutlet UIImageView* background;
	
}

-(IBAction)signIn;
-(IBAction)signUp;

@end
