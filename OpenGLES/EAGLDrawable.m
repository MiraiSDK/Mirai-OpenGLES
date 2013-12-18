//
//  EAGLDrawable.m
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#import "EAGLDrawable.h"

NSString * const kEAGLDrawablePropertyRetainedBacking = @"kEAGLDrawablePropertyRetainedBacking";
NSString * const kEAGLDrawablePropertyColorFormat = @"kEAGLDrawablePropertyColorFormat";
NSString * const kEAGLColorFormatRGBA8 = @"kEAGLColorFormatRGBA8";
NSString * const kEAGLColorFormatRGB565 = @"kEAGLColorFormatRGB565";
NSString * const kEAGLColorFormatSRGBA8 = @"kEAGLColorFormatSRGBA8";// NS_AVAILABLE_IOS(7_0);

@implementation EAGLContext (EAGLContextDrawableAdditions)

- (BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable
{
    return YES;
}

- (BOOL)presentRenderbuffer:(NSUInteger)target
{
    return YES;
}

@end