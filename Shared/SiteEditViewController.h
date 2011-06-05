//
//  SiteEditViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/2/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Site.h"


@interface SiteEditViewController : UITableViewController {

	Site* site;
	
}

@property (retain) Site* site;

@end
