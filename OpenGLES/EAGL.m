//
//  EAGL.m
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#import "EAGL.h"

void EAGLGetVersion(unsigned int* major, unsigned int* minor)
{
    *major = EAGL_MAJOR_VERSION;
    *minor = EAGL_MINOR_VERSION;
}

@implementation EAGLSharegroup
- (id)initWithAPI:(EAGLRenderingAPI)api
{
    self = [super init];
    return self;
}
@end

@implementation EAGLContext

static EAGLContext *ctx = nil;

+ (BOOL)setCurrentContext:(EAGLContext *)context
{
    ctx = context;
    return YES;
}

+ (EAGLContext *)currentContext
{
    return ctx;
}

- (id)init
{
    // TODO:// what's iOS default?
    return [self initWithAPI:kEAGLRenderingAPIOpenGLES1];
}

- (id)initWithAPI:(EAGLRenderingAPI)api
{
    return [self initWithAPI:api sharegroup:nil];
}

- (id)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup
{
    self = [super init];
    if (self) {
        _API = api;
        _sharegroup = sharegroup;
        
        _debugLabel = sharegroup.debugLabel;
    }
    return self;
}

@end

