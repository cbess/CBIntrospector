//
//  CBAppDelegate.m
//  CBIntrospectDemo
//
//  Created by Christopher Bess on 7/27/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import "CBAppDelegate.h"
#import "CBIntrospectDemoViewController.h"
#import "CBIntrospect.h"

@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // must be set before any nib is called
    [CBIntrospect setIntrospectorKeyName:@"introspectorName"];
    
    // create a custom tap gesture recognizer so introspection can be invoked from a device
	// this one is a three finger double tap
    /*
     UITapGestureRecognizer *defaultGestureRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
     defaultGestureRecognizer.cancelsTouchesInView = NO;
     defaultGestureRecognizer.delaysTouchesBegan = NO;
     defaultGestureRecognizer.delaysTouchesEnded = NO;
     defaultGestureRecognizer.numberOfTapsRequired = 2;
     defaultGestureRecognizer.numberOfTouchesRequired = 1;
     [CBIntrospect sharedIntrospector].invokeGestureRecognizer = defaultGestureRecognizer;
     */
    
    // Override point for customization after application launch.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
	// always insert this AFTER makeKeyAndVisible so statusBarOrientation is reported correctly.
	[[CBIntrospect sharedIntrospector] start];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
