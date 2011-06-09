//
//  SiteEditViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/2/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HudViewController.h"
#import "Site.h"

typedef void(^CancelBlock)(void);
typedef void(^DoneBlock)(Site*);

@interface SiteEditViewController : HudViewController <UIActionSheetDelegate> {

	UITableView* tableView;
	
	Site* site;
	CancelBlock cancelBlock;
	DoneBlock doneBlock;
	
}

@property (retain) UITableView* tableView;
@property (retain) Site* site;
@property (copy) CancelBlock cancelBlock;
@property (copy) DoneBlock doneBlock;

@end
