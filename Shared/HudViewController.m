    //
//  HudViewController.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/7/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "HudViewController.h"


static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation HudViewController

@synthesize hud;

- (void)showHud:(NSString*)aLabel
{
	if( self.hud==nil ) {
		DDLogVerbose(@"showHud");
		self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
		hud.delegate = self;
		hud.labelText = aLabel;
		hud.removeFromSuperViewOnHide = YES;
		[self.view addSubview:hud];
		[hud show:YES];
	}
}

- (void)hideHud
{
	if( self.hud ) {
		DDLogVerbose(@"hideHud");
		[self.hud hide:YES];
	}
}

#pragma mark -
#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD*)aHud
{
//	[aHud removeFromSuperview];
	self.hud = nil;
}

#pragma mark -

- (void)dealloc 
{
	[hud release];
    [super dealloc];
}


@end
