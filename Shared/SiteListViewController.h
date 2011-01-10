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


@interface SiteListViewController : UITableViewController <SiteRequestDelegate> {

	NSArray* sites;
	UISegmentedControl* control;
	MBProgressHUD* hud;
	
}

@property (retain) NSArray* sites;
@property (retain) MBProgressHUD* hud;
@property (retain) UISegmentedControl* control;


@end
