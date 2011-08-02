//
//  AccountViewController_Pad.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 7/17/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "AccountViewController_Pad.h"
#import "SubscriptionListViewController_Shared.h"
#import "MobileNavigationController.h"


@implementation AccountViewController_Pad

- (void)showSubscriptionSelect
{
	SubscriptionListViewController_Shared* tSubs = [[[SubscriptionListViewController_Shared alloc] init] autorelease];
	tSubs.successBlock = ^(NSString* aProductIdentifier) {
		async_main(^{
			[self.navigationController dismissModalViewControllerAnimated:YES];
			[self refreshUser];
		});
	};
	tSubs.cancelBlock = ^{ 
		async_main(^{
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	};
	MobileNavigationController* tWrapper = [[[MobileNavigationController alloc] initWithRootViewController:tSubs] autorelease];
	[self.navigationController presentModalViewController:tWrapper animated:YES];
}

@end

