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


@implementation AppDelegate_Shared

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	// start flurry session
	[FlurryAPI startSession:@"5JTUR7IT3A12S4XS1EIE"];

	// setup logging
	[DDLog addLogger:[DDTTYLogger sharedInstance]];

	NSString* tHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerUrl"];
	if( tHost==nil ) {
		tHost = @"http://uptimetry.com/api/";
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


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}

#pragma mark -
#pragma mark Sign In/Out

- (void)didSignIn
{
	[navigationController popToRootViewControllerAnimated:NO];
	[publicViewController.view removeFromSuperview];
	[window addSubview:navigationController.view];
}

- (void)didSignOut
{
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc
{
	[window release];
	[super dealloc];
}

@end
