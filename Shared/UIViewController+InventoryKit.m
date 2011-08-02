//
//  UIViewController+InventoryKit.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/7/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "UIViewController+InventoryKit.h"


static int ddLogLevel = LOG_LEVEL_ERROR;

@implementation UIViewController (InventoryKit)

- (IBAction)showUpgrade
{
	if( [SKPaymentQueue canMakePayments] ) {
		SKProductsRequest* tRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductDisableAd]];
		tRequest.delegate = self;
		[self showHud:@"Connecting to iTunes"];
		[tRequest start];
	}else{
		Alert(@"iTunes Unavailable",@"Can not connect to iTunes.");
	}
}

#pragma mark -
#pragma mark SKProductRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[self hideHud];
	DDLogVerbose(@"product response received");
	DDLogVerbose(@"invalid product ids: %@",response.invalidProductIdentifiers);
	DDLogVerbose(@"valid products:");
	for (SKProduct* tProduct in response.products) {
		DDLogVerbose(@"title: %@",tProduct.localizedTitle);
		DDLogVerbose(@"description: %@",tProduct.localizedDescription);
		DDLogVerbose(@"price: %@",tProduct.price);
		DDLogVerbose(@"productId: %@",tProduct.productIdentifier);
	}
	if( response.products.count>0 ) {
		for (SKProduct* tProduct in response.products) {
			if( [tProduct.productIdentifier isEqualToString:kProductDisableAd] ) {
				UIActionSheet* tAction = [[[UIActionSheet alloc] initWithTitle:tProduct.localizedDescription delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:tProduct.localizedTitle,nil] autorelease];
				[tAction showInView:self.view];
				break;
			}
		}
	}else if( [response.invalidProductIdentifiers containsObject:kProductDisableAd] ) {
		Alert(@"Product Unavailable",@"Please try again later.");
	}else{
		Alert(@"Oops!",@"The app encountered an unknown error.");
	}
	[request autorelease];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( buttonIndex==0 ) {
		[InventoryKit purchaseProduct:kProductDisableAd delegate:self];
	}
}

@end
