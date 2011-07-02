//
//  SubscriptionListViewController_Shared.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/29/11.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>
#import "InventoryKit.h"


typedef void (^SubscriptionCancelBlock)(void);
typedef void (^SubscriptionBlock)(NSString*);


@interface SubscriptionListViewController_Shared : UITableViewController <MBProgressHUDDelegate,SKProductsRequestDelegate,IKPurchaseDelegate> {

	NSArray* subscriptions;
	
	SubscriptionBlock successBlock;
	SubscriptionCancelBlock cancelBlock;
	
	MBProgressHUD* hud;
	
}

@property (retain) NSArray* subscriptions;
@property (copy) SubscriptionBlock successBlock;
@property (copy) SubscriptionCancelBlock cancelBlock;
@property (retain) MBProgressHUD* hud;

@end
