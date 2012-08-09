//
//  CBIntrospect.m
//  DCIntrospectDemo
//
//  Created by Christopher Bess on 5/2/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import "CBIntrospect.h"
#import "UIView+Introspector.h"
#import <sys/stat.h>
#import "JSONKit.h"
#import "DCUtility.h"
#import "CBIntrospectConstants.h"
#import "DLStatementParser.h"
#import "DLInvocationResult.h"

static NSString * const kDLIntrospectPreviousStatementKey = @"DLIntrospectPreviousStatementKey";
static NSString * const kDLIntrospectStatementHistoryKey = @"DLIntrospectStatementHistoryKey";

@interface CBIntrospect () <UIAlertViewDelegate, UITextFieldDelegate>
{
    NSArray *_ignoreDumpSubviews;
}
@property (nonatomic, strong) UIAlertView *alertView;
- (void)sync;
@end

@implementation CBIntrospect
@synthesize syncFileSystemState = _syncFileSystemState;

#pragma mark - Properties

- (void)setStatusBarOverlay:(DCStatusBarOverlay *)statusBarOverlay
{
	statusBarOverlay.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = CB_AutoRelease([[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCodeAlertView)]);
	statusBarOverlay.gestureRecognizers = [NSArray arrayWithObject:tapGesture];
	
	[super setStatusBarOverlay:statusBarOverlay];
}

- (void)setSyncFileSystemState:(CBIntrospectSyncFileSystemState)syncFileSystemState
{
    _syncFileSystemState = syncFileSystemState;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sync) object:nil];
    
    switch (syncFileSystemState)
    {
        case CBIntrospectSyncFileSystemStarted:
            [self sync];
            break;
            
        case CBIntrospectSyncFileSystemStopped:
            [UIView unlinkView:self.currentView];
            break;
            
        default:
            break;
    }
}

#pragma mark - Sync

- (void)sync
{
    [self syncNow];
    
    // create the loop (polling the file system)
    if (self.syncFileSystemState == CBIntrospectSyncFileSystemStarted)
        [self performSelector:@selector(sync) withObject:nil afterDelay:0.3];
}

- (void)syncNow
{
    BOOL doSync = NO;
    // only one view json file at a time
    NSString *syncFilePath = [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBCurrentViewFileName];
    const char *filepath = [syncFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    struct stat sb;
    // check the mod time
    if (stat(filepath, &sb) == 0)
    {
        doSync = (_lastModTime.tv_sec != sb.st_mtimespec.tv_sec);
    }
    
    if (doSync)
    {
        // get the view info
        NSError *error = nil;
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:syncFilePath
                                                               encoding:NSUTF8StringEncoding
                                                                  error:&error];
        NSDictionary *jsonInfo = [jsonString objectFromJSONString];
        
        // if the mem address in the current view json is different, then point `self.currentView`
        // to the target memory address
        if (![self updateCurrentViewWithMemoryAddress:[jsonInfo valueForKey:kUIViewMemoryAddressKey]])
        { // the current view did not change, then update the current view
            // update the current view
            if ([self.currentView updateWithJSON:jsonInfo])
            {
                [self updateFrameView];
                [self updateStatusBar];
            }
        }
        
        CB_Release(jsonString);
    }
    
    // read and execute the 'uiview message' sent from the introspector tool
    [self readSentViewMessage];
    
    // store last mod time
    _lastModTime = sb.st_mtimespec;
}

- (BOOL)readSentViewMessage
{
    NSError *error = nil;
    NSString *messageFilePath = [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBViewMessageFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:messageFilePath])
        return NO;
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:messageFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        NSAssert(NO, @"Unable to read the sent view mesage: %@", error);
        return NO;
    }
    
    NSDictionary *messageInfo = [jsonString objectFromJSONString];
    NSString *statement = [messageInfo objectForKey:kUIViewMessageKey];
    
    // if EXC_BAD_ACCESS, try reloading the tree
    NSInvocation *invocation = [DLStatementParser invocationForStatement:statement error:&error];
    [invocation invoke];
    
    // get the results (the response from the message)
    DLInvocationResult *invocationResult = [[DLInvocationResult alloc] initWithInvokedInvocation:invocation];
//    NSString *memAddress = [messageInfo objectForKey:kUIViewMemoryAddressKey];
//    UIView *view = [self viewWithMemoryAddress:memAddress];
//    NSString *message = [NSString stringWithFormat:@"%@: <%@: 0x%@> = %@", self.class, view.class, memAddress, invocationResult.resultDescription];
    NSString *message = nil;
    if (error)
    {
        message = error.localizedDescription;
    }
    else
    {
        message = [NSString stringWithFormat:@"%@: %@ = %@", self.class, statement, invocationResult.resultDescription];
    }
    
    NSLog(@"%@", message);
    
    // write the response back to the client

    CB_Release(jsonString);
    CB_Release(invocationResult);
    
    // remove the file after it has been used/read
    return [[NSFileManager defaultManager] removeItemAtPath:messageFilePath error:nil];
}

#pragma mark - Misc

// Returns the view at the specified mem address (0x9575200, minus the `0x`)
- (UIView *)viewWithMemoryAddress:(NSString *)memAddress
{
    // convert the memaddres to a pointer
    unsigned addr = 0;
    [[NSScanner scannerWithString:memAddress] scanHexInt:&addr];
    
    UIView *view = (__bridge UIView *)((void*)addr);
    return view;
}

- (BOOL)updateCurrentViewWithMemoryAddress:(NSString *)memAddress
{
    // if mem address different than current view, then get mem address of the target view
    if (![memAddress isEqualToString:self.currentView.memoryAddress])
    {
        UIView *view = [self viewWithMemoryAddress:memAddress];
        [self selectView:view];
        return YES;
    }
    
    return NO;
}

- (void)setupIgnoreDumpViews
{
    // an array of NSString objects that represent the class name of each
    // UIView class that will NOT be traversed during a view tree dump
    _ignoreDumpSubviews = [NSArray arrayWithObjects:
                           @"UISlider",
                           @"UITableViewCell",
                           nil];
}

- (NSString *)versionName
{
    return @"v0.3";
}

#pragma mark - Overrides

- (void)onWillSelectView:(UIView *)view
{
    [super onWillSelectView:view];
    
    self.syncFileSystemState = CBIntrospectSyncFileSystemStopped;   
}

- (void)onDidSelectView:(UIView *)view
{
    [super onDidSelectView:view];
    
    if (view)
        self.syncFileSystemState = CBIntrospectSyncFileSystemStarted;
}

- (void)updateFrameView
{
    [super updateFrameView];
    
    if (self.on)
    {
        [UIView storeView:self.currentView];
    }
}

- (void)invokeIntrospector
{
    [super invokeIntrospector];
   
    // remove the current view file
    [[NSFileManager defaultManager] removeItemAtPath:[[DCUtility sharedInstance] currentViewJSONFilePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[DCUtility sharedInstance] viewMessageJSONFilePath] error:nil];
    
    if (self.on)
    {
        [self dumpWindowViewTree];
        self.syncFileSystemState = CBIntrospectSyncFileSystemStarted;
    }
    else
    {
        // remove the view tree json
        [[NSFileManager defaultManager] removeItemAtPath:[[DCUtility sharedInstance] viewTreeJSONFilePath] error:nil];
    }
}

- (void)start
{
    [super start];
    
    // clear the json
    [[NSFileManager defaultManager] removeItemAtPath:[[DCUtility sharedInstance] currentViewJSONFilePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[DCUtility sharedInstance] viewTreeJSONFilePath] error:nil];
}

#pragma mark - Traverse Subviews

- (BOOL)canDumpView:(UIView *)view
{
    NSString *className = [NSStringFromClass([view class]) lowercaseString];
    if ([className hasPrefix:@"_uipopover"])
        return YES;
    
    if ([className hasPrefix:@"_"])
        return NO;
    
    return YES;
}

- (BOOL)canDumpSubviewsOfView:(UIView *)view
{
    NSString *className = NSStringFromClass([view class]);
    for (NSString *name in _ignoreDumpSubviews)
    {
        if ([name isEqualToString:className])
            return NO;
    }
    return YES;
}

- (void)dumpWindowViewTree
{
    NSMutableDictionary *treeDictionary = [self.mainWindow.dictionaryRepresentation mutableCopy];
    
    [self dumpSubviewsOfRootView:self.mainWindow toDictionary:treeDictionary];
    
    // write json to disk
    NSString *jsonString = [treeDictionary JSONString];
    NSString *path = [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBTreeDumpFileName];
    [[DCUtility sharedInstance] writeString:jsonString toPath:path];
    CB_Release(treeDictionary);
}

- (void)dumpSubviewsOfRootView:(UIView *)rootView toDictionary:(NSMutableDictionary *)treeInfo
{
    NSMutableArray *viewArray = [NSMutableArray arrayWithCapacity:rootView.subviews.count];
    
    // traverse subviews
    for (UIView *view in rootView.subviews)
    {
        if ([self shouldIgnoreView:view])
            continue;
        
        if (![self canDumpView:view])
            continue;
        
        // add subview info to root view dictionary
        NSMutableDictionary *viewInfo = [view.dictionaryRepresentation mutableCopy];
        [viewArray addObject:viewInfo];
        
        if ([self canDumpSubviewsOfView:view])
            [self dumpSubviewsOfRootView:view toDictionary:viewInfo];
        
        CB_Release(viewInfo);
    }
    
    [treeInfo setObject:viewArray forKey:kUIViewSubviewsKey];
}

#pragma mark - Code execution

- (void)showCodeAlertView;
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Execute Code:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Perform", nil];
	alertView = CB_AutoRelease(alertView);
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	
	UITextField *textField = [alertView textFieldAtIndex:0];
	textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kDLIntrospectPreviousStatementKey];
    textField.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    textField.delegate = self;
	
	[alertView show];
    self.alertView = alertView;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex)
		return;
	
	UITextField *textField = [alertView textFieldAtIndex:0];
	NSString *text = textField.text;
	if (text.length == 0)
		return;
	
	[[NSUserDefaults standardUserDefaults] setObject:text forKey:kDLIntrospectPreviousStatementKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSString *viewHexAddress = [NSString stringWithFormat:@"0x%@", self.currentView.memoryAddress];
	text = [text stringByReplacingOccurrencesOfString:@"self" withString:viewHexAddress];
	
	NSError *error = nil;
	NSInvocation *invocation = [DLStatementParser invocationForStatement:text error:&error];
	
	if (error)
	{
		NSLog(@"%@: %@", self.class, error);
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		errorAlert = CB_AutoRelease(errorAlert);
		[errorAlert show];
	}
	else
	{
		[invocation invoke];
		
		DLInvocationResult *result = [DLInvocationResult resultWithInvokedInvocation:invocation];
		NSString *resultDescription = [result resultDescription];
		NSLog(@"%@: %@", self.class, resultDescription);
		
		if ([resultDescription isEqualToString:@"(null)"] == NO)
		{
			UIAlertView *descriptionAlert = [[UIAlertView alloc] initWithTitle:@"Result" message:resultDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			descriptionAlert = CB_AutoRelease(descriptionAlert);
			[descriptionAlert show];
		}
		
        // store the statement info in the history
		NSMutableArray *history = [[[NSUserDefaults standardUserDefaults] objectForKey:kDLIntrospectStatementHistoryKey] mutableCopy];
		history = CB_AutoRelease(history);
		if (!history)
			history = [NSMutableArray arrayWithCapacity:1];
		NSDictionary *dict = @{ text : @"statement", resultDescription : @"result" };
		[history addObject:dict];
		[[NSUserDefaults standardUserDefaults] setObject:history forKey:kDLIntrospectStatementHistoryKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    self.alertView = nil;
}

#pragma mark - Text View Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.alertView dismissWithClickedButtonIndex:1 animated:YES];
    return YES;
}

@end
