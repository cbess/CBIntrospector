//
//  UIView+Introspector.m
//  DCIntrospectDemo
//
//  Created by Christopher Bess on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Introspector.h"
#import "CBMacros.h"
#import "DCUtility.h"
#import "NSObject+JSON.h"
#import "CBIntrospectConstants.h"
#include <stdbool.h>
#include <sys/types.h>
#import <objc/runtime.h>
#import "CBIntrospect.h"

// expands to a string representation of the object memory address
#define MEM_STR(obj) [NSString stringWithFormat:@"%lx", (unsigned long)obj]

@interface UIView (Custom)
+ (NSString *)filePathWithView:(UIView *)view;
@end

@implementation UIView (Introspector)
@dynamic memoryAddress;
@dynamic introspectorName;

+ (NSString *)describeProperty:(NSString *)propertyName value:(id)value
{
#ifdef DEBUG
	if ([propertyName isEqualToString:@"contentMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIViewContentModeScaleToFill";
			case 1: return @"UIViewContentModeScaleAspectFit";
			case 2: return @"UIViewContentModeScaleAspectFill";
			case 3: return @"UIViewContentModeRedraw";
			case 4: return @"UIViewContentModeCenter";
			case 5: return @"UIViewContentModeTop";
			case 6: return @"UIViewContentModeBottom";
			case 7: return @"UIViewContentModeLeft";
			case 8: return @"UIViewContentModeRight";
			case 9: return @"UIViewContentModeTopLeft";
			case 10: return @"UIViewContentModeTopRight";
			case 11: return @"UIViewContentModeBottomLeft";
			case 12: return @"UIViewContentModeBottomRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"textAlignment"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAlignmentLeft";
			case 1: return @"UITextAlignmentCenter";
			case 2: return @"UITextAlignmentRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"lineBreakMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UILineBreakModeWordWrap";
			case 1: return @"UILineBreakModeCharacterWrap";
			case 2: return @"UILineBreakModeClip";
			case 3: return @"UILineBreakModeHeadTruncation";
			case 4: return @"UILineBreakModeTailTruncation";
			case 5: return @"UILineBreakModeMiddleTruncation";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"activityIndicatorViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIActivityIndicatorViewStyleWhiteLarge";
			case 1: return @"UIActivityIndicatorViewStyleWhite";
			case 2: return @"UIActivityIndicatorViewStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"returnKeyType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIReturnKeyDefault";
			case 1: return @"UIReturnKeyGo";
			case 2: return @"UIReturnKeyGoogle";
			case 3: return @"UIReturnKeyJoin";
			case 4: return @"UIReturnKeyNext";
			case 5: return @"UIReturnKeyRoute";
			case 6: return @"UIReturnKeySearch";
			case 7: return @"UIReturnKeySend";
			case 8: return @"UIReturnKeyYahoo";
			case 9: return @"UIReturnKeyDone";
			case 10: return @"UIReturnKeyEmergencyCall";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardAppearance"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardAppearanceDefault";
			case 1: return @"UIKeyboardAppearanceAlert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UIKeyboardTypeASCIICapable";
			case 2: return @"UIKeyboardTypeNumbersAndPunctuation";
			case 3: return @"UIKeyboardTypeURL";
			case 4: return @"UIKeyboardTypeNumberPad";
			case 5: return @"UIKeyboardTypePhonePad";
			case 6: return @"UIKeyboardTypeNamePhonePad";
			case 7: return @"UIKeyboardTypeEmailAddress";
			case 8: return @"UIKeyboardTypeDecimalPad";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocorrectionType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UITextAutocorrectionTypeDefault";
			case 2: return @"UITextAutocorrectionTypeNo";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocapitalizationType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAutocapitalizationTypeNone";
			case 1: return @"UITextAutocapitalizationTypeWords";
			case 2: return @"UITextAutocapitalizationTypeSentences";
			case 3: return @"UITextAutocapitalizationTypeAllCharacters";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"clearButtonMode"] ||
			 [propertyName isEqualToString:@"leftViewMode"] ||
			 [propertyName isEqualToString:@"rightViewMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextFieldViewModeNever";
			case 1: return @"UITextFieldViewModeWhileEditing";
			case 2: return @"UITextFieldViewModeUnlessEditing";
			case 3: return @"UITextFieldViewModeAlways";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"borderStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextBorderStyleNone";
			case 1: return @"UITextBorderStyleLine";
			case 2: return @"UITextBorderStyleBezel";
			case 3: return @"UITextBorderStyleRoundedRect";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"progressViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIProgressViewStyleBar";
			case 1: return @"UIProgressViewStyleDefault";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"separatorStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSeparatorStyleNone";
			case 1: return @"UITableViewCellSeparatorStyleSingleLine";
			case 2: return @"UITableViewCellSeparatorStyleSingleLineEtched";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"selectionStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSelectionStyleNone";
			case 1: return @"UITableViewCellSelectionStyleBlue";
			case 2: return @"UITableViewCellSelectionStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"editingStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellEditingStyleNone";
			case 1: return @"UITableViewCellEditingStyleDelete";
			case 2: return @"UITableViewCellEditingStyleInsert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"accessoryType"] || [propertyName isEqualToString:@"editingAccessoryType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellAccessoryNone";
			case 1: return @"UITableViewCellAccessoryDisclosureIndicator";
			case 2: return @"UITableViewCellAccessoryDetailDisclosureButton";
			case 3: return @"UITableViewCellAccessoryCheckmark";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"style"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewStylePlain";
			case 1: return @"UITableViewStyleGrouped";
			default: return nil;
		}
		
	}
	else if ([propertyName isEqualToString:@"autoresizingMask"])
	{
		UIViewAutoresizing mask = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (mask & UIViewAutoresizingFlexibleLeftMargin)
			[string appendString:@"UIViewAutoresizingFlexibleLeftMargin"];
		if (mask & UIViewAutoresizingFlexibleRightMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleRightMargin"];
		if (mask & UIViewAutoresizingFlexibleTopMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleTopMargin"];
		if (mask & UIViewAutoresizingFlexibleBottomMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleBottomMargin"];
		if (mask & UIViewAutoresizingFlexibleWidth)
			[string appendString:@" | UIViewAutoresizingFlexibleWidthMargin"];
		if (mask & UIViewAutoresizingFlexibleHeight)
			[string appendString:@" | UIViewAutoresizingFlexibleHeightMargin"];
		
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIViewAutoresizingNone";
	}
	else if ([propertyName isEqualToString:@"accessibilityTraits"])
	{
		UIAccessibilityTraits traits = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (traits & UIAccessibilityTraitButton)
			[string appendString:@"UIAccessibilityTraitButton"];
		if (traits & UIAccessibilityTraitLink)
			[string appendString:@" | UIAccessibilityTraitLink"];
		if (traits & UIAccessibilityTraitSearchField)
			[string appendString:@" | UIAccessibilityTraitSearchField"];
		if (traits & UIAccessibilityTraitImage)
			[string appendString:@" | UIAccessibilityTraitImage"];
		if (traits & UIAccessibilityTraitSelected)
			[string appendString:@" | UIAccessibilityTraitSelected"];
		if (traits & UIAccessibilityTraitPlaysSound)
			[string appendString:@" | UIAccessibilityTraitPlaysSound"];
		if (traits & UIAccessibilityTraitKeyboardKey)
			[string appendString:@" | UIAccessibilityTraitKeyboardKey"];
		if (traits & UIAccessibilityTraitStaticText)
			[string appendString:@" | UIAccessibilityTraitStaticText"];
		if (traits & UIAccessibilityTraitSummaryElement)
			[string appendString:@" | UIAccessibilityTraitSummaryElement"];
		if (traits & UIAccessibilityTraitNotEnabled)
			[string appendString:@" | UIAccessibilityTraitNotEnabled"];
		if (traits & UIAccessibilityTraitUpdatesFrequently)
			[string appendString:@" | UIAccessibilityTraitUpdatesFrequently"];
		if (traits & UIAccessibilityTraitStartsMediaSession)
			[string appendString:@" | UIAccessibilityTraitStartsMediaSession"];
		if (traits & UIAccessibilityTraitAdjustable)
			[string appendFormat:@" | UIAccessibilityTraitAdjustable"];
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIAccessibilityTraitNone";
	}
	
	if ([value isKindOfClass:[NSValue class]])
	{
		// print out the return for each value depending on type
		NSString *type = [NSString stringWithUTF8String:[value objCType]];
		if ([type isEqualToString:@"c"])
		{
			return [value boolValue] ? @"YES" : @"NO";
		}
		else if ([type isEqualToString:@"{CGSize=ff}"])
		{
			CGSize size = [value CGSizeValue];
			return CGSizeEqualToSize(size, CGSizeZero) ? @"CGSizeZero" : NSStringFromCGSize(size);
		}
		else if ([type isEqualToString:@"{UIEdgeInsets=ffff}"])
		{
			UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
			return UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero) ? @"UIEdgeInsetsZero" : NSStringFromUIEdgeInsets(edgeInsets);
		}
	}
	else if ([value isKindOfClass:[UIColor class]])
	{
		UIColor *color = (UIColor *)value;
		return [[DCUtility sharedInstance] describeColor:color];
	}
	else if ([value isKindOfClass:[UIFont class]])
	{
		UIFont *font = (UIFont *)value;
		return [NSString stringWithFormat:@"%.0fpx %@", font.pointSize, font.fontName];
	}
#endif
    
	return value ? [value description] : @"nil";
}

#pragma mark - Persistence

+ (NSString *)filePathWithView:(UIView *)view;
{
    // uncomment below line to create unique filenames for each selected view
    //    NSString *filename = [NSString stringWithFormat:@"%@.%x.view.json", NSStringFromClass([view class]), view]; // gen unique filenames
    NSString *filename = kCBCurrentViewFileName;
    return [[[DCUtility sharedInstance] cacheDirectoryPath] stringByAppendingPathComponent:filename];
}

+ (void)storeView:(UIView *)view
{
    NSString *jsonString = [view JSONString];
    NSError *error = nil;
    
    // store the json file
    [jsonString writeToFile:[self filePathWithView:view]
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:&error];
    
    NSAssert(error == nil, @"error saving view: %@", error);
}

+ (void)restoreView:(UIView *)view
{
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[self filePathWithView:view]
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
    NSDictionary *jsonInfo = [jsonString objectFromJSONString];
    if ([view updateWithJSON:jsonInfo])
    {
        // success
    }
    else
    {
        // fail
    }
    
    NSAssert(error == nil, @"error reading view: %@", error);
#if ! __has_feature(objc_arc)
    [jsonString release];
#endif
}

+ (void)unlinkView:(UIView *)view
{
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathWithView:view] error:nil];
}

#pragma mark - UIView Overrides

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([[CBIntrospect introspectorKeyName] isEqualToString:key])
        self.introspectorName = value;
    else
        [super setValue:value forUndefinedKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([[CBIntrospect introspectorKeyName] isEqualToString:key])
        return self.introspectorName;
    
    return [super valueForUndefinedKey:key];
}

#pragma mark - Transform

- (NSDictionary *)dictionaryRepresentation
{
    // build the JSON/dictionary
    NSMutableDictionary *jsonInfo = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [jsonInfo setObject:self.introspectorName forKey:kUIViewClassNameKey];
    [jsonInfo setObject:MEM_STR(self) forKey:kUIViewMemoryAddressKey];
    [jsonInfo setObject:self.viewDescription forKey:kUIViewDescriptionKey];
    
    [jsonInfo setObject:NSStringFromCGRect(self.bounds) forKey:kUIViewBoundsKey];
    [jsonInfo setObject:NSStringFromCGPoint(self.center) forKey:kUIViewCenterKey];
    [jsonInfo setObject:NSStringFromCGRect(self.frame) forKey:kUIViewFrameKey];
    
    [jsonInfo setObject:@(self.alpha) forKey:kUIViewAlphaKey];
    [jsonInfo setObject:@(self.hidden) forKey:kUIViewHiddenKey];
    
    return jsonInfo;
}

- (NSString *)JSONString
{
    return [[self dictionaryRepresentation] JSONString];
}

- (BOOL)updateWithJSON:(NSDictionary *)jsonInfo
{
    // check class and mem address    
    NSString *memAddress = [jsonInfo valueForKey:kUIViewMemoryAddressKey];
    if (![MEM_STR(self) isEqualToString:memAddress])
    {
        CBDebugLog(@"Bad memory address for current view from JSON: 0x%@", memAddress);
        return NO;
    }
    else if (![[jsonInfo valueForKey:kUIViewClassNameKey] isEqualToString:NSStringFromClass([self class])])
    {
        CBDebugLog(@"Bad class name for memory address: 0x%@", memAddress);
        return NO;
    }
    
    self.hidden = [[jsonInfo valueForKey:kUIViewHiddenKey] boolValue];
    self.alpha = [[jsonInfo valueForKey:kUIViewAlphaKey] floatValue];
    
    // only update what was changed, frame overrides all (because it is a calculation of bounds & center)
    CGRect newBounds = CGRectFromString([jsonInfo valueForKey:kUIViewBoundsKey]);
    BOOL changedBounds = (!CGRectEqualToRect(newBounds, self.bounds));
    
    CGPoint newCenter = CGPointFromString([jsonInfo valueForKey:kUIViewCenterKey]);
    BOOL changedCenter = (!CGPointEqualToPoint(newCenter, self.center));
    
    CGRect newFrame = CGRectFromString([jsonInfo valueForKey:kUIViewFrameKey]);
    BOOL changedFrame = (!CGRectEqualToRect(newFrame, self.frame));
        
    if (changedBounds)
        self.bounds = newBounds;
    
    if (changedCenter)
        self.center = newCenter;
    
    if (changedFrame)
        self.frame = newFrame;
    
    return YES;
}

- (NSString *)syncFilePath
{
    return [UIView filePathWithView:self];
}

- (NSString *)memoryAddress
{
    return MEM_STR(self);
}

- (NSString *)introspectorName
{
    return [[CBIntrospect sharedIntrospector] nameForObject:self];
}

- (void)setIntrospectorName:(NSString *)introspectorName
{
    [[CBIntrospect sharedIntrospector] setName:introspectorName forObject:self accessedWithSelf:NO];
}

#pragma mark - View Description

- (NSString *)viewDescription
{
	NSMutableString *outputString = nil;
    
#ifdef DEBUG
    Class objectClass = [self class];
	NSString *className = [NSString stringWithFormat:@"%@:0x%@", objectClass, MEM_STR(self)];
	outputString = [NSMutableString stringWithFormat:@"\n\n** %@", className];
	
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    size_t buf_size = 1024;
    char *buffer = malloc(buf_size);
    
	// list the class heirachy
	Class superClass = [objectClass superclass];
	while (superClass)
	{
		[outputString appendFormat:@" : %@", superClass];
		superClass = [superClass superclass];
	}
	
	[outputString appendString:@" ** \n\n"];
	
	if ([objectClass isSubclassOfClass:UIView.class])
	{
		UIView *view = (UIView *)self;
		// print out generic uiview properties
		[outputString appendString:@"  ** UIView properties **\n"];
//        [outputString appendFormat:@"    introspectorName: %@\n", self.introspectorName];
		[outputString appendFormat:@"    tag: %i\n", view.tag];
		[outputString appendFormat:@"    frame: %@ | ", NSStringFromCGRect(view.frame)];
		[outputString appendFormat:@"bounds: %@ | ", NSStringFromCGRect(view.bounds)];
		[outputString appendFormat:@"center: %@\n", NSStringFromCGPoint(view.center)];
		[outputString appendFormat:@"    transform: %@\n", NSStringFromCGAffineTransform(view.transform)];
		[outputString appendFormat:@"    autoresizingMask: %@\n", [UIView describeProperty:@"autoresizingMask" value:[NSNumber numberWithInt:view.autoresizingMask]]];
		[outputString appendFormat:@"    autoresizesSubviews: %@\n", NSStringFromBOOL(view.autoresizesSubviews)];
		[outputString appendFormat:@"    contentMode: %@ | ", [UIView describeProperty:@"contentMode" value:[NSNumber numberWithInt:view.contentMode]]];
//		[outputString appendFormat:@"contentStretch: %@\n", NSStringFromCGRect(view.contentStretch)];
		[outputString appendFormat:@"    backgroundColor: %@\n", [[DCUtility sharedInstance] describeColor:view.backgroundColor]];
		[outputString appendFormat:@"    alpha: %.2f | ", view.alpha];
		[outputString appendFormat:@"opaque: %@ | ", NSStringFromBOOL(view.opaque)];
		[outputString appendFormat:@"hidden: %@ | ", NSStringFromBOOL(view.hidden)];
		[outputString appendFormat:@"clipsToBounds: %@ | ", NSStringFromBOOL(view.clipsToBounds)];
		[outputString appendFormat:@"clearsContextBeforeDrawing: %@\n", NSStringFromBOOL(view.clearsContextBeforeDrawing)];
		[outputString appendFormat:@"    userInteractionEnabled: %@ | ", NSStringFromBOOL(view.userInteractionEnabled)];
		[outputString appendFormat:@"multipleTouchEnabled: %@\n", NSStringFromBOOL(view.multipleTouchEnabled)];
		[outputString appendFormat:@"    gestureRecognizers: %@\n", (view.gestureRecognizers) ? [view.gestureRecognizers description] : @"nil"];
        [outputString appendFormat:@"    superview: %@\n", view.superview.description];
        
        // get subviews instance info
        NSMutableArray *subviewsArray = [NSMutableArray arrayWithCapacity:view.subviews.count];
        for (UIView *subview in view.subviews) 
        {
            [subviewsArray addObject:[NSString stringWithFormat:@"<%@: 0x%@>", NSStringFromClass([subview class]), MEM_STR(subview)]];
        }
        
        // ex: subviews: 3 views [<UIView: 0x23f434f>, <UIButton: 0x43f4ffe>]
        [outputString appendFormat:@"    subviews: %d view%@ [%@]\n", view.subviews.count, (view.subviews.count == 1 ? @"" : @"s"), [subviewsArray componentsJoinedByString:@", "]];
		[outputString appendString:@"\n"];
	}
	
	[outputString appendFormat:@"  ** %@ properties **\n", objectClass];
	
    // custom property descriptions
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView*) self;
        [outputString appendFormat:@"    contentOffset: %@\n", NSStringFromCGPoint(scrollView.contentOffset)];
        [outputString appendFormat:@"    contentSize: %@\n", NSStringFromCGSize(scrollView.contentSize)];
    }
	
    // descriptions for dynamic property discovery
	if (objectClass == UIButton.class)
	{
		[outputString appendString:@"    Logging properties not currently supported for this view.\n"];
	}
	else
	{
		for (unsigned int i = 0; i < count; ++i)
		{
			// get the property name and selector name
			NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
			
			SEL sel = NSSelectorFromString(propertyName);
			if ([self respondsToSelector:sel])
			{
				NSString *propertyDescription;
				@try
				{
					// get the return object and type for the selector
					NSString *returnType = [NSString stringWithUTF8String:[[self methodSignatureForSelector:sel] methodReturnType]];
					id returnObject = [self valueForKey:propertyName];
					if ([returnType isEqualToString:@"c"])
						returnObject = @([returnObject intValue] != 0);
					
					propertyDescription = [UIView describeProperty:propertyName value:returnObject];
				}
				@catch (NSException *exception)
				{
					// Non KVC compliant properties, see also +workaroundUITextInputTraitsPropertiesBug
					propertyDescription = @"N/A";
				}
				[outputString appendFormat:@"    %@: %@\n", propertyName, propertyDescription];
			}
		}
	}
	
	// list targets if there are any
	if ([self respondsToSelector:@selector(allTargets)])
	{
		[outputString appendString:@"\n  ** Targets & Actions **\n"];
		UIControl *control = (UIControl *)self;
		UIControlEvents controlEvents = [control allControlEvents];
		NSSet *allTargets = [control allTargets];
        for (id target in allTargets)
        {
            NSArray *actions = [control actionsForTarget:target forControlEvent:controlEvents];
            for (id action in actions)
            {
                [outputString appendFormat:@"    [%@ %@]\n", [target description], action];
            }
        }
	}
	
	[outputString appendString:@"\n"];
    
	free(properties);
    free(buffer);
#endif
    
    return outputString;
}

@end
