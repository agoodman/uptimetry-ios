//
//  HudViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/7/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface HudViewController : UIViewController <MBProgressHUDDelegate> {

	MBProgressHUD* hud;
	
}

@property (retain) MBProgressHUD* hud;

-(void)showHud:(NSString*)aLabel;
-(void)hideHud;

@end
