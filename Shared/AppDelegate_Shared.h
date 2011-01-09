//
//  AppDelegate_Shared.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileNavigationController.h"
#import "SignInViewController.h"
#import "PublicViewController.h"


@interface AppDelegate_Shared : NSObject <UIApplicationDelegate,SignInDelegate> {

	UIWindow* window;
	MobileNavigationController* navigationController;
	PublicViewController* publicViewController;
	
}

-(void)didSignIn;
-(void)didSignOut;

@property (retain) IBOutlet UIWindow* window;
@property (retain) IBOutlet MobileNavigationController* navigationController;
@property (retain) IBOutlet PublicViewController* publicViewController;

@end
