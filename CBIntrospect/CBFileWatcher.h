//
//  CBFileWatcher.h
//  CBIntrospectDemo
//
//  Created by C. Bess on 11/21/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBFileWatcher : NSObject

- (void)addFilePath:(NSString *)path;
- (void)removeFilePath:(NSString *)path;

/**
 * Checks the watched file paths.
 * @return File paths that have changed since the previous call of this method.
 */
- (NSArray *)changedFilePaths;
@end
