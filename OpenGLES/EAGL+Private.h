//
//  EAGL+Private.h
//  OpenGLES
//
//  Created by Chen Yonghui on 11/8/14.
//  Copyright (c) 2014 Shanghai TinyNetwork Inc. All rights reserved.
//

#import "EAGL.h"

@interface EAGLSharegroup ()
- (id)initWithAPI:(EAGLRenderingAPI)api;
@property (nonatomic, weak) EAGLContext *context;
@end

@interface EAGLContext()
- (id)initWithAPI:(EAGLRenderingAPI)api eglContext:(void *)ctx eglSurface:(void *)surface sharegroup:(EAGLSharegroup *)sharegroup;
@end