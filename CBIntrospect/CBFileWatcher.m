//
//  CBFileWatcher.m
//  CBIntrospectDemo
//
//  Created by C. Bess on 11/21/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import "CBFileWatcher.h"
#import <sys/stat.h>
#import "CBMacros.h"

@interface CBFileWatcher ()
// key: file path
// value: number representing the last mod time
@property (nonatomic, strong) NSMutableDictionary *filePathInfo;
@end

@implementation CBFileWatcher

- (NSDictionary *)filePathInfo
{
    if (_filePathInfo == nil)
        _filePathInfo = [NSMutableDictionary dictionary];
    return _filePathInfo;
}

- (void)dealloc
{
    self.filePathInfo = nil;
    CB_NO_ARC([super dealloc]);
}

#pragma mark -

- (void)addFilePath:(NSString *)path
{
    [self.filePathInfo setObject:@0 forKey:path];
}

- (void)removeFilePath:(NSString *)path
{
    NSSet *keySet = [self.filePathInfo keysOfEntriesPassingTest:^BOOL(NSString *aPath, NSNumber *lastMod, BOOL *stop) {
        return [path isEqualToString:aPath];
    }];
    
    [self.filePathInfo removeObjectForKey:keySet.anyObject];
}

- (NSArray *)changedFilePaths
{
    NSMutableDictionary *tmpInfo = [self.filePathInfo copy];
    NSSet *keySet = [tmpInfo keysOfEntriesPassingTest:^BOOL(NSString *path, NSNumber *lastMod, BOOL *stop) {
        BOOL doSync = NO;
        long tvsec = lastMod.longValue;
        const char *filepath = [path cStringUsingEncoding:NSUTF8StringEncoding];
        struct stat sb;
        // check the mod time
        if (stat(filepath, &sb) == 0)
        {
            doSync = (tvsec != sb.st_mtimespec.tv_sec);
        }
        
        // store last mod time
        [self.filePathInfo setObject:@(sb.st_mtimespec.tv_sec) forKey:path];
        return doSync;
    }];
    
    CB_Release(tmpInfo)
    
    return keySet.allObjects;
}
@end
