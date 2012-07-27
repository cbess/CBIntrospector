//
//  CBMacros.h
//  CBIntrospector
//
//  Created by Christopher Bess on 5/12/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#ifndef CBIntrospector_CBMacros_h
#define CBIntrospector_CBMacros_h

#pragma mark - ARC Support
#define CB_HAS_ARC __has_feature(objc_arc)

#if CB_HAS_ARC
#define cbstrong strong
#define cbweak weak
#define CB_NO_ARC(BLOCK_NO_ARC) ;
#define CB_IF_ARC(BLOCK_ARC, BLOCK_NO_ARC) BLOCK_ARC
#else
#define cbstrong retain
#define cbweak assign
#define CB_NO_ARC(BLOCK_NO_ARC) BLOCK_NO_ARC
#define CB_IF_ARC(BLOCK_ARC, BLOCK_NO_ARC) BLOCK_NO_ARC
#endif

#define CB_Release(OBJ) CB_NO_ARC([OBJ release]); OBJ = nil;
#define CB_AutoRelease(OBJ) CB_IF_ARC(OBJ, [OBJ autorelease]);
#define CB_Retain(OBJ) CB_IF_ARC(OBJ, [OBJ retain]);

#pragma mark - Debug
#ifdef DEBUG
#define CBDebugLog(MSG, ...) NSLog((@"%s:%d "MSG), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define CBDebugMark() CBDebugLog(@"called");
// outputs the specified code block (can be multi-line)
#define CBDebugCode(BLOCK) BLOCK
#else
#define CBDebugLog(MSG, ...) ;
#define CBDebugMark() ;
#define CBDebugCode(BLOCK) ;
#endif

#endif
