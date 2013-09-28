//
//  NSObject+JSON.m
//  ViewIntrospector
//
//  Created by Markus Emrich on 11.02.13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "NSObject+JSON.h"

static NSData * NSDataFromJSONObject(id object)
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    return data;
}

@implementation NSString (JSON)

- (id)objectFromJSONString;
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    return object;
}

@end


@implementation NSDictionary (JSON)

- (NSString *)JSONString;
{
    NSData *data = NSDataFromJSONObject(self);
    return (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
}

@end


@implementation NSArray (JSON)

- (NSString *)JSONString;
{
    NSData *data = NSDataFromJSONObject(self);
    return (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
}

@end
