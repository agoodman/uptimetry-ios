//
//  SiteListViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteRequest.h"
#import "MBProgressHUD.h"
#import "DoubleLabelTextFieldViewController.h"


@interface SiteListViewController : UITableViewController <SiteRequestDelegate,DoubleLabelTextFieldDelegate> {

	NSArray* sites;
	UISegmentedControl* control;
	MBProgressHUD* hud;

	Site* editingSite;
	
}

@property (retain) NSArray* sites;
@property (retain) MBProgressHUD* hud;
@property (retain) UISegmentedControl* control;

-(void)showWhatsNext;

@end
