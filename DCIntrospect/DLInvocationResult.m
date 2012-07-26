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

@interface DLInvocationResult ()
@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, strong) NSMethodSignature *methodSignature;
@property (nonatomic) void *result;
@end

@implementation DLInvocationResult
@synthesize invocation = _invocation;
@synthesize methodSignature = _methodSignature;
@synthesize result = _result;

+ (id)resultWithInvokedInvocation:(NSInvocation *)invocation;
{
	return [[[[self class] alloc] initWithInvokedInvocation:invocation] autorelease];
}

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@"%@", [self resultDescription]];
}

#pragma mark - Object lifecycle
- (id)initWithInvokedInvocation:(NSInvocation *)invocation
{
	self = [super init];
	if (self)
	{
		_invocation = [invocation retain];
		_methodSignature = [invocation methodSignature];
		if (_methodSignature.methodReturnType[0] != _C_VOID)
			[invocation getReturnValue:&_result];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - Private
- (NSString *)descriptionForBitFold:(int)bitFold
{
	// TODO: Implement returning a binary visualization of the int
	return [NSString stringWithFormat:@"Bitfold: %i", (int)self.result];
}

#pragma mark - Public
- (const char *)type
{
	return self.methodSignature.methodReturnType;
}

- (NSString *)resultDescription
{
	NSString *description = nil;
	
	// TODO: Finish implementing this
	switch (self.methodSignature.methodReturnType[0])
	{
		case _C_ID:       // '@'
			if ([(id)self.result conformsToProtocol:@protocol(NSObject)])
				description = [(NSObject *)self.result description];
			else
				description = [NSString stringWithFormat:@"Object at memory address %p doesn't conform to NSObject protocol", (id)self.result];
			break;
		case _C_CLASS:    // '#'
			description = NSStringFromClass(self.result);
			break;
		case _C_SEL:      // ':'
			description = NSStringFromSelector(self.result);
			break;
		case _C_CHR:      // 'c'
			description = [NSString stringWithFormat:@"%c", (int)self.result];
			break;
		case _C_UCHR:     // 'C'
			description = [NSString stringWithFormat:@"%C", (unsigned short)self.result];
			break;
		case _C_SHT:      // 's'
			description = [NSString stringWithFormat:@"%hi", (short)self.result];
			break;
		case _C_USHT:     // 'S'
			description = [NSString stringWithFormat:@"%hu", (unsigned short)self.result];
			break;
		case _C_INT:      // 'i'
			description = [NSString stringWithFormat:@"%i", (int)self.result];
			break;
		case _C_UINT:     // 'I'
			description = [NSString stringWithFormat:@"%u", (unsigned int)self.result];
			break;
		case _C_LNG:      // 'l'
			description = [NSString stringWithFormat:@"%ld", (long)self.result];
			break;
		case _C_ULNG:     // 'L'
			description = [NSString stringWithFormat:@"%lu", (unsigned long)self.result];
			break;
		case _C_LNG_LNG:  // 'q'
			description = [NSString stringWithFormat:@"%qi", (long long)self.result]; // or '%lld'
			break;
		case _C_ULNG_LNG: // 'Q'
			description = [NSString stringWithFormat:@"%qu", (unsigned long long)self.result]; // or '%llu"
			break;
		case _C_FLT:      // 'f'
        {
            // test this, but this will suppress the error for now
            NSString *format = @"%f";
			description = [NSString stringWithFormat:format, self.result]; // or '%g', '%ld"
        }
			break;
		case _C_DBL:      // 'd'
        {
            NSString *format = @"%f";
			description = [NSString stringWithFormat:format, self.result];
        }
			break;
		case _C_BFLD:     // 'b'
			description = [self descriptionForBitFold:(int)self.result];
			break;
		case _C_BOOL:     // 'B'
			description = (self.result ? @"YES" : @"NO");
			break;
		case _C_VOID:     // 'v'
			description = @"(null)";
			break;
		case _C_UNDEF:    // '?'
		case _C_PTR:      // '^'
		case _C_CHARPTR:  // '*'
		case _C_ATOM:     // '%'
		case _C_ARY_B:    // '['
		case _C_ARY_E:    // ']'
		case _C_UNION_B:  // '('
		case _C_UNION_E:  // ')'
		case _C_STRUCT_B: // '{'
		case _C_STRUCT_E: // '}'
		case _C_VECTOR:   // '!'
		case _C_CONST:    // 'r'
			
		default:
			description = [NSString stringWithFormat:@"Description for type '%c' not yet supported", (int)[NSString stringWithUTF8String:self.type]];
			break;
	}
	
	return description;
}

@end
