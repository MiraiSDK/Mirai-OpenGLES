//
//  EAGLDrawable.h
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#ifndef _EAGL_DRAWABLE_H_
#define _EAGL_DRAWABLE_H_

#include <OpenGLES/EAGL.h>

//EAGL_EXTERN NSString * const kEAGLDrawablePropertyRetainedBacking;
//EAGL_EXTERN NSString * const kEAGLDrawablePropertyColorFormat;
//EAGL_EXTERN NSString * const kEAGLColorFormatRGBA8;
//EAGL_EXTERN NSString * const kEAGLColorFormatRGB565;
//EAGL_EXTERN NSString * const kEAGLColorFormatSRGBA8 NS_AVAILABLE_IOS(7_0);

@protocol EAGLDrawable
@property(copy) NSDictionary* drawableProperties;
@end

@interface EAGLContext (EAGLContextDrawableAdditions)
- (BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable;
- (BOOL)presentRenderbuffer:(NSUInteger)target;

@end /* EAGLDrawable protocol */

#endif /* _EAGL_DRAWABLE_H_ */
