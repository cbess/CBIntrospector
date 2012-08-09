//
//  CBViewMessengerWindow.m
//  CBIntrospector
//
//  Created by Christopher Bess on 7/25/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import "CBViewMessengerWindow.h"
#import "CBIntrospectorWindow.h"
#import "CBUIView.h"
#import "JSONKit.h"


@interface CBViewMessengerWindow ()
@property (assign) IBOutlet NSButton *receiverViewButton;
@property (assign) IBOutlet NSTextField *messageTextField;
@property (assign) IBOutlet NSButton *sendButton;
@property (assign) IBOutlet NSTextView *responseTextView;

@end

@implementation CBViewMessengerWindow
@synthesize receiverViewButton;
@synthesize messageTextField;
@synthesize sendButton;
@synthesize responseTextView;
@synthesize receiverView = _receiverView;
@synthesize introspectorWindow;

- (void)awakeFromNib
{
    [self.sendButton setEnabled:NO];
    self.responseTextView.font = [NSFont fontWithName:@"Monaco" size:12];
}

- (void)setReceiverView:(CBUIView *)receiverView
{
    if (receiverView == _receiverView)
        return;
    
    CB_Release(_receiverView);
    _receiverView = CB_Retain(receiverView);
    
    // load the window
    if (receiverView)
        self.receiverViewButton.title = nssprintf(@"<%@: 0x%@>", receiverView.className, receiverView.memoryAddress);
    else
        self.receiverViewButton.title = @"UIView";
    
    [self.sendButton setEnabled:receiverView != nil];
}

- (void)makeKeyAndOrderFront:(id)sender
{
    [super makeKeyAndOrderFront:sender];
    
    [self.messageTextField becomeFirstResponder];
}

- (IBAction)receiverViewButtonClicked:(id)sender 
{
    // select the view in the tree
    [self.introspectorWindow makeKeyAndOrderFront:nil];
    [self.introspectorWindow selectTreeItemWithMemoryAddress:self.receiverView.memoryAddress];
}

- (IBAction)sendMessageButtonClicked:(id)sender
{
    NSString *message = self.messageTextField.stringValue;
    if (!message.length || !self.receiverView)
    {
        [[CBUtility sharedInstance] showMessageBoxWithString:@"No message to send."];
        return;
    }
    
    // replace `self`
    NSString *rawMessage = [message stringByReplacingOccurrencesOfString:@"self" withString:[@"0x" stringByAppendingString:self.receiverView.memoryAddress]];
    
    NSMutableDictionary *messageInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [messageInfo setObject:self.receiverView.memoryAddress forKey:kUIViewMemoryAddressKey];
    [messageInfo setObject:rawMessage forKey:kUIViewMessageKey];
    
    if ([self writeMessageJSON:messageInfo])
    {
        // append message
        NSString *logString = [message stringByReplacingOccurrencesOfString:@"self" withString:nssprintf(@"<%@: 0x%@>", self.receiverView.className, self.receiverView.memoryAddress)];
        self.responseTextView.string = [self.responseTextView.string stringByAppendingFormat:@"\n=> %@", logString];
    }
}

#pragma mark - Misc

- (BOOL)writeMessageJSON:(NSDictionary *)jsonInfo
{
    // save to disk
    NSError *error = nil;
    NSString *jsonString = [jsonInfo JSONString];
    [jsonString writeToFile:[self.introspectorWindow.syncDirectoryPath stringByAppendingPathComponent:kCBViewMessageFileName]
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:&error];
    if (error)
    {
        NSAssert(NO, @"Failed to save JSON: %@", error);
        return NO;
    }
    
    return YES;
}

- (void)clearHistory
{
    self.responseTextView.string = @"";
}
@end
