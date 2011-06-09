//
//  UIViewController+InventoryKit.h
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/7/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InventoryKit.h"


@interface UIViewController (InventoryKit) <SKProductsRequestDelegate,IKPurchaseDelegate>

-(IBAction)showUpgrade;

@end
