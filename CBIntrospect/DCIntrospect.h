//
//  DCIntrospect.h
//
//  Created by Domestic Cat on 29/04/11.
//

#define kDCIntrospectNotificationIntrospectionDidStart @"kDCIntrospectNotificationIntrospectionDidStart"
#define kDCIntrospectNotificationIntrospectionDidEnd @"kDCIntrospectNotificationIntrospectionDidEnd"
#define kDCIntrospectAnimationDuration 0.08

#import <objc/runtime.h>
#include "TargetConditionals.h"
#import "CBMacros.h"
#import "DCIntrospectSettings.h"
#import "DCFrameView.h"
#import "DCStatusBarOverlay.h"

@interface UIView (debug)

- (NSString *)recursiveDescription;

@end


@interface DCIntrospect : NSObject <DCFrameViewDelegate, UITextViewDelegate, UIWebViewDelegate>
{
}

@property (nonatomic) BOOL keyboardBindingsOn;									// default: YES
@property (nonatomic) BOOL showStatusBarOverlay;								// default: YES
@property (nonatomic, cbstrong) UIGestureRecognizer *invokeGestureRecognizer;		// default: nil

@property (nonatomic) BOOL on;
@property (nonatomic) BOOL handleArrowKeys;
@property (nonatomic) BOOL viewOutlines;
@property (nonatomic) BOOL highlightNonOpaqueViews;
@property (nonatomic) BOOL flashOnRedraw;
@property (nonatomic, cbstrong) DCFrameView *frameView;
@property (nonatomic, cbstrong) UITextView *inputTextView;
@property (nonatomic, cbstrong) DCStatusBarOverlay *statusBarOverlay;

@property (nonatomic, cbstrong) NSMutableDictionary *objectNames;

@property (nonatomic, assign) UIView *currentView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGFloat originalAlpha;
@property (nonatomic, cbstrong) NSMutableArray *currentViewHistory;

@property (nonatomic) BOOL showingHelp;

///////////
// Setup //
///////////

+ (instancetype)sharedIntrospector;		// this returns nil when NOT in DEGBUG mode
- (void)start;								// NOTE: call setup AFTER [window makeKeyAndVisible] so statusBarOrientation is reported correctly.

////////////////////
// Custom Setters //
////////////////////

- (void)setInvokeGestureRecognizer:(UIGestureRecognizer *)newGestureRecognizer;
- (void)setKeyboardBindingsOn:(BOOL)keyboardBindingsOn;

//////////////////
// Main Actions //
//////////////////

- (void)invokeIntrospector;					// can be called manually
- (void)touchAtPoint:(CGPoint)point;		// can be called manually
- (void)selectView:(UIView *)view;
- (void)statusBarTapped;

//////////////////////
// Keyboard Capture //
//////////////////////

- (void)textViewDidChangeSelection:(UITextView *)textView;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;

/////////////////////////////////
// Logging Code & Object Names //
/////////////////////////////////

- (void)logCodeForCurrentViewChanges;

// make sure all names that are added are removed at dealloc or else they will be retained here!
- (void)setName:(NSString *)name forObject:(id)object accessedWithSelf:(BOOL)accessedWithSelf;
- (NSString *)nameForObject:(id)object;
- (void)removeNamesForViewsInView:(UIView *)view;
- (void)removeNameForObject:(id)object;

////////////
// Layout //
////////////

- (void)updateFrameView;
- (void)updateStatusBar;
- (void)updateViews;
- (void)showTemporaryStringInStatusBar:(NSString *)string;

/////////////
// Actions //
/////////////

- (void)logRecursiveDescriptionForCurrentView;
- (void)logRecursiveDescriptionForView:(UIView *)view;
- (void)forceSetNeedsDisplay;
- (void)forceSetNeedsLayout;
- (void)forceReloadOfView;
- (void)toggleOutlines;
- (void)addOutlinesToFrameViewFromSubview:(UIView *)view;
- (void)toggleNonOpaqueViews;
- (void)setBackgroundColor:(UIColor *)color ofNonOpaqueViewsInSubview:(UIView *)view;
- (void)toggleRedrawFlashing;
- (void)callDrawRectOnViewsInSubview:(UIView *)subview;
- (void)flashRect:(CGRect)rect inView:(UIView *)view;

/////////////////////////////
// (Somewhat) Experimental //
/////////////////////////////

- (void)logPropertiesForCurrentView;
- (void)logPropertiesForView:(UIView *)view;
- (void)logAccessabilityPropertiesForObject:(id)object;

/////////////////////////
// Description Methods //
/////////////////////////

- (NSString *)describeProperty:(NSString *)propertyName value:(id)value;

/////////////////////////
// DCIntrospector Help //
/////////////////////////

- (void)toggleHelp;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

////////////////////
// Helper Methods //
////////////////////

- (UIWindow *)mainWindow;
- (NSMutableArray *)viewsAtPoint:(CGPoint)touchPoint inView:(UIView *)view;
- (void)fadeView:(UIView *)view toAlpha:(CGFloat)alpha;
- (BOOL)view:(UIView *)view containsSubview:(UIView *)subview;
- (BOOL)shouldIgnoreView:(UIView *)view;

#pragma mark - Misc

- (NSString *)startInstructionsText;
- (NSString *)versionName;

#pragma mark - Select View Delegate
- (void)onWillDeselectView:(UIView *)view;
- (void)onWillSelectView:(UIView *)view;
- (void)onDidSelectView:(UIView *)view;
@end
