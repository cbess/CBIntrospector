//
//  CBIntrospect.h
//  DCIntrospectDemo
//
//  Created by Christopher Bess on 5/2/12.
//  Copyright (c) 2012 Christopher Bess of Quantum Quinn. All rights reserved.
//

#import "DCIntrospect.h"
#import <time.h>

// Specifies the current state of the file system sync
typedef enum {
    // Sync has been activated
    CBIntrospectSyncFileSystemStarted,
    // Sync is no longer active
    CBIntrospectSyncFileSystemStopped,
} CBIntrospectSyncFileSystemState;

@interface CBIntrospect : DCIntrospect

@property (nonatomic, assign) CBIntrospectSyncFileSystemState syncFileSystemState;

/**
 * Gets/sets the introspector key name that can be used to provide a name for objects in the introspector.
 * @discussion This value is set within IB, using the "User Defined Runtime Properties" panel. Used in
 * the View Introspector and CBIntrospect output. Therefore it must be set before nibs are loaded. 
 */
+ (void)setIntrospectorKeyName:(NSString *)keyName;
+ (NSString *)introspectorKeyName;

/**
 Starts the introspector by watching for the gesture that matches the specified tap criteria.
 @discussion This will facilitate more reliable iOS support on or off device. You can set `invokeGestureRecognizer`
 to override or provide a more complex gesture to invoke the instrospector.
 */
- (void)startWithInvokeGestureWithNumberOfTaps:(NSUInteger)numberOfTaps touchesRequired:(NSUInteger)touchesRequired;

/**
 Starts the introspector using a default gesture.
 @disucssion Default is two taps from a single finger (simulator: double-click)
 */
- (void)startWithDefaultInvokeGesture;

/**
 * Syncs the changes from the file system back to the corresponding iOS view.
 */
- (void)syncNow;

/**
 * Sets the view's name in the object tree from the specified view controller.
 * @discussion Use within [viewDidLoad].
 */
- (void)setNameForViewController:(UIViewController *)viewController;

- (void)listenForRemoteNotifications;

@end
