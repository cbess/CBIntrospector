//
//  NSObject+JSON.h
//  ViewIntrospector
//
//  Created by Markus Emrich on 11.02.13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

- (id)objectFromJSONString;

@end


@interface NSDictionary (JSON)

- (NSString *)JSONString;

@end


@interface NSArray (JSON)

- (NSString *)JSONString;

@end
