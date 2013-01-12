//
//  CBAppDelegate.h
//  CBIntrospectDemo
//
//  Created by Christopher Bess on 7/27/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBIntrospectDemoViewController;

@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CBIntrospectDemoViewController *viewController;

@end
