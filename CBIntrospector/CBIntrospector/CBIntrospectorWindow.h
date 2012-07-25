//
//  CBWindow.h
//  CBIntrospector
//
//  Created by Christopher Bess on 5/2/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CBUIViewManager;

@interface CBIntrospectorWindow : NSWindow
@property (nonatomic, readonly) NSString *simulatorDirectoryPath;
@property (nonatomic, readonly) NSString *syncDirectoryPath;
@property (nonatomic, strong) NSDictionary *treeContents;
@property (nonatomic, readonly) CBUIViewManager *viewManager;
- (void)switchProjectToDirectoryPath:(NSString *)path;
- (void)selectTreeItemWithMemoryAddress:(NSString *)memAddress;
@end
