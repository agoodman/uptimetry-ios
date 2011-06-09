    //
//  HudViewController.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 6/7/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "HudViewController.h"


@implementation HudViewController

@synthesize hud;

- (void)showHud:(NSString*)aLabel
{
	self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	hud.delegate = self;
	hud.labelText = aLabel;
	[self.view addSubview:hud];
	[hud show:YES];
}

- (void)hideHud
{
	[self.hud hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD*)aHud
{
	[aHud removeFromSuperview];
	self.hud = nil;
}

#pragma mark -

- (void)dealloc 
{
	[hud release];
    [super dealloc];
}


@end
