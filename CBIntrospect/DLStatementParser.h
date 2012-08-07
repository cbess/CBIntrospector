//
//  DLStatementParser.h
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

#import <Foundation/Foundation.h>
#import "DLInvocationResult.h"

typedef enum {
	DLStatementParserErrorUnknown = 0,
	DLStatementParserErrorStartingOpenBracketNotFound = 10,
	DLStatementParserErrorClosingCloseBracketNotFound = 11,
	DLStatementParserErrorClassNameNotFound = 20,
	DLStatementParserErrorClassNameInvalid = 21,
	DLStatementParserErrorClassDoesNotRespondToSelector = 22,
	DLStatementParserErrorInstanceDoesNotRespondToSelector = 30,
	DLStatementParserErrorMethodNameNotFound = 40,
	DLStatementParserErrorMethodNameInvalid = 41,
	DLStatementParserErrorParameterTypeUnknown = 50,
	DLStatementParserErrorParameterNotFound = 51,
	DLStatementParserErrorParameterIsInvalidStruct = 52,
	DLStatementParserErrorParameterReturnValueDifferentFromSelectorArgumentValue = 53
} DLStatementParserError;
extern NSString * const DLStatementParserErrorUserInfoDescriptionKey;


@interface DLStatementParser : NSObject

+ (NSInvocation *)invocationForStatement:(NSString *)statement error:(NSError **)error;

@end
