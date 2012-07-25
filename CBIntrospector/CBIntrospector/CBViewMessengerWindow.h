//
//  CBViewMessengerWindow.h
//  CBIntrospector
//
//  Created by Christopher Bess on 7/25/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CBIntrospectorWindow;
@class CBUIView;

@interface CBViewMessengerWindow : NSWindow
@property (nonatomic, assign) CBIntrospectorWindow *introspectorWindow;
@property (nonatomic, strong) CBUIView *receiverView;
@end
