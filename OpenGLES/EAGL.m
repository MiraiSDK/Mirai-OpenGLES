//
//  EAGL.m
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#import "EAGL.h"
#import <pthread.h>

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

void pthread_key_destructor_callback(void *value)
{
    EAGLContext *ctx = (__bridge_transfer EAGLContext *)(value);
}
static pthread_key_t key = 0;


+ (void)initialize
{
    pthread_key_create(&key, &pthread_key_destructor_callback);
}

+ (BOOL)setCurrentContext:(EAGLContext *)context
{
    EAGLContext *prevContext = (__bridge_transfer EAGLContext *)(pthread_getspecific(key));
    int r = pthread_setspecific(key, (__bridge_retained const void *)(context));
    return (r == 0);
}

+ (EAGLContext *)currentContext
{
    EAGLContext *c = (__bridge EAGLContext *)(pthread_getspecific(key));
    return c;
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
        if (!_sharegroup) {
            _sharegroup = [[EAGLSharegroup alloc] initWithAPI:api];
        }
        _debugLabel = sharegroup.debugLabel;
    }
    return self;
}

@end

