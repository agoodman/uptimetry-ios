//
//  SiteListViewController.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SiteRequest.h"
#import "MBProgressHUD.h"
#import "DoubleLabelTextFieldViewController.h"
#import "InventoryKit.h"
#import <StoreKit/StoreKit.h>


@interface SiteListViewController : UIViewController <SiteRequestDelegate,DoubleLabelTextFieldDelegate,ADBannerViewDelegate,MBProgressHUDDelegate,IKPurchaseDelegate,SKProductsRequestDelegate,UIActionSheetDelegate> {

	NSArray* sites;
	IBOutlet UITableView* tableView;
	IBOutlet UIView* slidingView;
	IBOutlet ADBannerView* banner;
	UISegmentedControl* control;
	MBProgressHUD* hud;

	Site* editingSite;
	CGRect visibleSlidingFramePortrait, hiddenSlidingFramePortrait;
	CGRect visibleTableFramePortrait, hiddenTableFramePortrait;
	CGRect visibleSlidingFrameLandscape, hiddenSlidingFrameLandscape;
	CGRect visibleTableFrameLandscape, hiddenTableFrameLandscape;
	BOOL bannerVisible;
}

@property (retain) NSArray* sites;
@property (retain) UITableView* tableView;
@property (retain) UIView* slidingView;
@property (retain) MBProgressHUD* hud;
@property (retain) UISegmentedControl* control;

-(void)showWhatsNext;
-(IBAction)showUpgrade;

@end
