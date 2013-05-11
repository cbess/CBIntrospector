//
//  DCUtility.m
//  DCIntrospectDemo
//
//  Created by Christopher Bess on 4/30/12.
//  Copyright (c) 2012 Christopher Bess. All rights reserved.
//

#import "DCUtility.h"
#import "CBIntrospectConstants.h"

#import <arpa/inet.h>
#import <netinet/in.h>
#import <stdio.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <unistd.h>
#import <ifaddrs.h>

@implementation DCUtility

+ (DCUtility *)sharedInstance
{
    static DCUtility *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [DCUtility new];
    });
    
    return sharedObj;
}

- (NSString *)cacheDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
	
	return libraryDirectory;
}

- (BOOL)writeString:(NSString *)string toPath:(NSString *)path
{
    NSError *error = nil;
    
    // store the json file
    [string writeToFile:path
             atomically:NO
               encoding:NSUTF8StringEncoding
                  error:&error];
    
    NSAssert(error == nil, @"error storing string: %@", error);
    
    return error == nil;
}

- (NSString *)currentViewJSONFilePath
{
    return [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBCurrentViewFileName];
}

- (NSString *)viewTreeJSONFilePath
{
    return [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBTreeDumpFileName];
}

- (NSString *)viewMessageJSONFilePath
{
    return [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBViewMessageFileName];
}

- (NSString *)filePathForSelectedViewJSON
{
    return [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:kCBSelectedViewFileName];
}

- (NSString *)describeColor:(UIColor *)color
{
	if (!color)
		return @"nil";
	
	NSString *returnString = nil;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelRGB)
	{
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		returnString = [NSString stringWithFormat:@"R: %.0f G: %.0f B: %.0f A: %.2f",
						components[0] * 256,
						components[1] * 256,
						components[2] * 256,
						components[3]];
	}
	else
	{
		returnString = [NSString stringWithFormat:@"%@ (incompatible color space)", color];
	}
	return returnString;
}

- (NSString *)IPAddressString
{	
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
	
	NSString *result = nil;
	
    // retrieve the current interfaces - returns 0 on success
    if (!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if (sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                //NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
				//NSLog(@"Interface \"%@\" addr %@", name, addr);
				
				if (!result ||
					[result isEqualToString:@"0.0.0.0"] ||
					([result isEqualToString:@"127.0.0.1"] && ![addr isEqualToString:@"0.0.0.0"])
					) {
					result = addr;
				}
                
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    return result ? result : @"0.0.0.0";
}

- (void)showMessageWithString:(NSString *)string
{
    [[[UIAlertView alloc] initWithTitle:nil
                               message:string
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
