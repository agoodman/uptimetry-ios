//
//  AppDelegate_Shared.m
//  Uptimetry
//
//  Created by Aubrey Goodman on 1/9/11.
//  Copyright 2011 Migrant Studios LLC. All rights reserved.
//

#import "AppDelegate_Shared.h"
#import "FlurryAPI.h"
#import "DDTTYLogger.h"
#import "InventoryKit.h"
#import "ASIHTTPRequest.h"


static int ddLogLevel = LOG_LEVEL_WARN;

@interface AppDelegate_Shared (private)
-(void)wakeUp;
@end


@implementation AppDelegate_Shared

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	// setup logging first!
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
		
	// configure IK to listen for payment transactions
	[InventoryKit registerWithPaymentQueue];
//	[InventoryKit useSandbox:YES];
	[InventoryKit setApiToken:@"d04d10eb3a"];

	// set default http timeout
	[ASIHTTPRequest setDefaultTimeOutSeconds:5];
	
	// start flurry session
	[FlurryAPI startSession:@"5JTUR7IT3A12S4XS1EIE"];

	// default server url
	NSString* tHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerUrl"];
	if( tHost==nil ) {
		tHost = @"http://uptimetry.com/api/";
//		tHost = @"http://sandbox.uptimetry.com/api/";
		[[NSUserDefaults standardUserDefaults] setValue:tHost forKey:@"ServerUrl"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// configure ObjectiveResource
	[ObjectiveResourceConfig setSite:tHost];
	[ObjectiveResourceConfig setResponseType:JSONResponse];

	if( [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"] ) {
		// signed in; show private view
		[self didSignIn];
	}else{
		// not signed in; show public view
		[self didSignOut];
	}

    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
	DDLogVerbose(@"willResignActive");
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	DDLogVerbose(@"didBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	DDLogVerbose(@"willTerminate");
}

#pragma mark -
#pragma mark Sign In/Out

- (void)didSignIn
{
	// configure IK with current user
	[InventoryKit setCustomerEmail:[[NSUserDefaults standardUserDefaults] stringForKey:@"UserEmail"]];
	
	DDLogVerbose(@"didSignIn");
	[navigationController popToRootViewControllerAnimated:NO];
	[publicViewController.view removeFromSuperview];
	[window addSubview:navigationController.view];

	float tAlertVersion = [[NSUserDefaults standardUserDefaults] floatForKey:@"AlertVersion"];
	if( tAlertVersion<0.91 ) {
		Alert(@"Welcome!",@"Thanks for using Uptimetry™.\nFind us on Twitter (@uptimetry) if you have questions or problems.");
		[[NSUserDefaults standardUserDefaults] setFloat:0.91 forKey:@"AlertVersion"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)didSignOut
{
	// configure IK with no active user
	[InventoryKit setCustomerEmail:nil];
	
	[publicViewController.view resignFirstResponder];
	DDLogVerbose(@"didSignOut");
	[navigationController.view removeFromSuperview];
	[window addSubview:publicViewController.view];
}

#pragma mark -
#pragma mark SignInDelegate

- (void)signedInWithUserId:(int)userId
{
	[self didSignIn];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
	DDLogVerbose(@"didReceiveMemoryWarning");
}


- (void)dealloc
{
	[window release];
	[super dealloc];
}

@end
