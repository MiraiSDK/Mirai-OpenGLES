//
//  EAGL.h
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#ifndef _EAGL_H_
#define _EAGL_H_

#include <Foundation/Foundation.h>

#ifdef __cplusplus
#define EAGL_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define EAGL_EXTERN extern __attribute__((visibility ("default")))
#endif

#define EAGL_EXTERN_CLASS __attribute__((visibility("default")))

#define EAGL_MAJOR_VERSION   1
#define EAGL_MINOR_VERSION   0

enum
{
	kEAGLRenderingAPIOpenGLES1 = 1,
	kEAGLRenderingAPIOpenGLES2 = 2,
	kEAGLRenderingAPIOpenGLES3 = 3,
};
typedef NSUInteger EAGLRenderingAPI;

EAGL_EXTERN void EAGLGetVersion(unsigned int* major, unsigned int* minor);

EAGL_EXTERN_CLASS
@interface EAGLSharegroup : NSObject
{
    @package
	struct _EAGLSharegroupPrivate *_private;
}

@property (copy, nonatomic) NSString* debugLabel;// NS_AVAILABLE_IOS(6_0);

@end


EAGL_EXTERN_CLASS
@interface EAGLContext : NSObject
{
@public
	struct _EAGLContextPrivate *_private;
}

- (id) initWithAPI:(EAGLRenderingAPI) api;
- (id) initWithAPI:(EAGLRenderingAPI) api sharegroup:(EAGLSharegroup*) sharegroup;

+ (BOOL)            setCurrentContext:(EAGLContext*) context;
+ (EAGLContext*)    currentContext;

@property (readonly) EAGLRenderingAPI   API;
@property (readonly) EAGLSharegroup*    sharegroup;

@property (copy, nonatomic) NSString* debugLabel;// NS_AVAILABLE_IOS(6_0);
@end

#endif /* _EAGL_H_ */

