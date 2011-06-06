//
//  SiteEditViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/2/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Site.h"

typedef void(^CancelBlock)(void);
typedef void(^DoneBlock)(Site*);

@interface SiteEditViewController : UITableViewController <UIActionSheetDelegate> {

	Site* site;
	CancelBlock cancelBlock;
	DoneBlock doneBlock;
	
}

@property (retain) Site* site;
@property (copy) CancelBlock cancelBlock;
@property (copy) DoneBlock doneBlock;

@end
