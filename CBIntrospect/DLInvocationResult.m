//
//  DLInvocationResult.m
//
//  Created by Daniel Leber on 7/9/12.
//	Copyright (c) 2012 Daniel Leber
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DLInvocationResult.h"
#import <objc/runtime.h>
#import "CBMacros.h"

@interface DLInvocationResult ()
@property (nonatomic, strong, readwrite) NSInvocation *invocation;
@end

@implementation DLInvocationResult
@synthesize invocation = _invocation;

+ (id)resultWithInvokedInvocation:(NSInvocation *)invocation;
{
	return CB_AutoRelease([[[self class] alloc] initWithInvokedInvocation:invocation])
}

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@", [self resultDescription]];
}

#pragma mark - Object lifecycle
- (id)initWithInvokedInvocation:(NSInvocation *)invocation
{
	self = [super init];
	if (self)
	{
		_invocation = CB_Retain(invocation)
	}
	return self;
}

- (void)dealloc
{
#if ! CB_HAS_ARC
	[_invocation release];
	[super dealloc];
#endif
}

#pragma mark - Private
- (NSString *)descriptionForUnsupportedType:(const char *)type
{
	return [NSString stringWithFormat:@"Description for type '%s' not yet supported", type];
}

#pragma mark - Public
- (const char *)resultType;
{
	return self.invocation.methodSignature.methodReturnType;
}

- (NSString *)resultDescription
{
	NSString *description = nil;
	const char *type = [self resultType];
    if (!type)
        return @"No type specified.";
    
	switch (type[0])
	{
		case _C_ID:       // '@'
		{
			id result;
			[self.invocation getReturnValue:&result];

			if ([result conformsToProtocol:@protocol(NSObject)])
			{
				NSObject *resultObject = (NSObject *)result;
				description = [resultObject description];
			}
			else
			{
				description = [NSString stringWithFormat:@"Object at memory address %p doesn't conform to NSObject protocol", result];
			}
		}
			break;
		case _C_CLASS:    // '#'
		{
			Class result;
			[self.invocation getReturnValue:&result];
			description = NSStringFromClass(result);
		}
			break;
		case _C_SEL:      // ':'
		{
			SEL result;
			[self.invocation getReturnValue:&result];
			description = NSStringFromSelector(result);
		}
			break;
		case _C_CHR:      // 'c'
		{
			char result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%hhd", result];
		}
			break;
		case _C_UCHR:     // 'C'
		{
			unsigned char result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%hhu", result];
		}
			break;
		case _C_SHT:      // 's'
		{
			short result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%hd", result];
		}
			break;
		case _C_USHT:     // 'S'
		{
			unsigned short result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%hu", result];
		}
			break;
		case _C_INT:      // 'i'
		{
			int result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%d", result];
		}
			break;
		case _C_UINT:     // 'I'
		{
			unsigned int result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%u", result];
		}
			break;
		case _C_LNG:      // 'l'
		{
			long result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%ld", result];
		}
			break;
		case _C_ULNG:     // 'L'
		{
			unsigned long result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%lu", result];
		}
			break;
		case _C_LNG_LNG:  // 'q'
		{
			long long result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%lld", result];
		}
			break;
		case _C_ULNG_LNG: // 'Q'
		{
			unsigned long long result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%llu", result];
		}
			break;
		case _C_FLT:      // 'f'
        {
			float result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%f", result];
        }
			break;
		case _C_DBL:      // 'd'
        {
			double result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"%f", result];
        }
			break;
		case _C_BFLD:     // 'b'
		{
//			void *result;
//			[self.invocation getReturnValue:&result];
			description = [NSString stringWithFormat:@"bitfield result is currently unsupported"];
		}
			break;
		case _C_BOOL:     // 'B'
		{
			BOOL result;
			[self.invocation getReturnValue:&result];
			description = (result ? @"YES" : @"NO");
		}
			break;
		case _C_VOID:     // 'v'
			description = @"(null)";
			break;
		case _C_UNDEF:    // '?'
			description = @"(undefined)";
			break;
		case _C_PTR:      // '^'
		{
			NSString *typeString = [NSString stringWithUTF8String:type];
			if ([typeString isEqualToString:@"^{CGColor=}"])
			{
				CGColorRef colorRef;
				[self.invocation getReturnValue:&colorRef];
				description = [NSString stringWithFormat:@"%@", colorRef];
			}
			else
				description = [self descriptionForUnsupportedType:(const char *)type];
		}
			break;
		case _C_CHARPTR:  // '*'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_ATOM:     // '%'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_ARY_B:    // '['
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_ARY_E:    // ']'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_UNION_B:  // '('
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_UNION_E:  // ')'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_STRUCT_B: // '{'
		{
			NSString *typeString = [NSString stringWithUTF8String:type];
			if ([typeString isEqualToString:@"{CGPoint=ff}"])
			{
				CGPoint result;
				[self.invocation getReturnValue:&result];
				description = NSStringFromCGPoint(result);
			}
			else if ([typeString isEqualToString:@"{CGSize=ff}"])
			{
				CGSize result;
				[self.invocation getReturnValue:&result];
				description = NSStringFromCGSize(result);
			}
			else if ([typeString isEqualToString:@"{CGRect={CGPoint=ff}{CGSize=ff}}"])
			{
				CGRect result;
				[self.invocation getReturnValue:&result];
				description = NSStringFromCGRect(result);
			}
			else
				description = [self descriptionForUnsupportedType:(const char *)type];
		}
			break;
		case _C_STRUCT_E: // '}'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_VECTOR:   // '!'
			description = [self descriptionForUnsupportedType:(const char *)type];
			break;
		case _C_CONST:    // 'r'
		{
			const char *result;
			[self.invocation getReturnValue:&result];
			description = [NSString stringWithUTF8String:result];
		}
			break;
			
		default:
			description = [NSString stringWithFormat:@"Warning! Unexpected return type: %s", type];
			break;
	}
	
	return description;
}

- (void *)result;
{
	void *result = nil;
	[self.invocation getReturnValue:&result];
	return result;
}


@end
