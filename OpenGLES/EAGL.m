//
//  EAGL.m
//  OpenGLES
//
//  Created by Chen Yonghui on 12/17/13.
//  Copyright (c) 2013 Shanghai TinyNetwork Inc. All rights reserved.
//

#import "EAGL.h"
#import "EAGL+Private.h"

#import <pthread.h>

#include <EGL/egl.h>
//#include <EGL/eglext.h>



void EAGLGetVersion(unsigned int* major, unsigned int* minor)
{
    *major = EAGL_MAJOR_VERSION;
    *minor = EAGL_MINOR_VERSION;
}

@interface EAGLSharegroup ()
@end
@implementation EAGLSharegroup
- (id)initWithAPI:(EAGLRenderingAPI)api
{
    self = [super init];
    return self;
}
@end

@implementation EAGLContext {
    EGLContext *_eglContext;
    EGLDisplay *_eglDisplay;
    EGLSurface *_eglSurface;
}

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

    if (r != 0) {
        return NO;
    }
    
    if (context == nil) {
        bool result = eglMakeCurrent(EGL_NO_DISPLAY, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        return result;
    }
    
    EGLSurface surface = context->_eglSurface;
    if (surface == EGL_NO_SURFACE) {
        [NSException raise:@"EGL_NO_SURFACE" format:@"context has no surface"];
        return NO;
    }
    
    BOOL success = eglMakeCurrent(context->_eglDisplay, surface, surface, context->_eglContext);
    if (!success) {
        NSLog(@"Unable to eglMakeCurrent");
    }
    
    return success;
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
        
        _eglDisplay = eglGetCurrentDisplay();
        if (_eglDisplay == EGL_NO_DISPLAY) {
            _eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
        }
        
        EGLConfig config;
        EGLint numConfigs;
        const EGLint attribs[] = {
            EGL_CONFORMANT, EGL_OPENGL_ES2_BIT,
            EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
            EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
            EGL_BLUE_SIZE, 8,
            EGL_GREEN_SIZE, 8,
            EGL_RED_SIZE, 8,
            EGL_STENCIL_SIZE, 8,
            EGL_NONE
        };

        EGLBoolean chooseSuccess = eglChooseConfig(_eglDisplay, attribs, &config, 1, &numConfigs);
        if (!chooseSuccess) {
            NSLog(@"choose config failed");
        }
        
        EGLSurface surface = EGL_NO_SURFACE;
        if (surface == EGL_NO_SURFACE) {
            NSLog(@"create pbuffer surface..");
            const EGLint pbAttribs[] = {
                EGL_WIDTH,700,
                EGL_HEIGHT,700,
                EGL_NONE
            };
            surface = eglCreatePbufferSurface(_eglDisplay, config, pbAttribs);
            
            if (surface == EGL_NO_SURFACE) {
                EGLint err = eglGetError();

                NSLog(@"%s create surface failed, error:%d",__PRETTY_FUNCTION__,err);
                
            }
            
        }
        _eglSurface = surface;

        const EGLint ctxAttribs[] = {
            EGL_CONTEXT_CLIENT_VERSION, api,
            EGL_NONE
        };
        
        EGLContext *sharedContext = EGL_NO_CONTEXT;
        if (sharegroup) {
            EAGLContext *sharegroupContent = sharegroup.context;
            if (sharegroupContent) {
                sharedContext = sharegroupContent->_eglContext;
            }
        }
        
        _eglContext = eglCreateContext(_eglDisplay, config, sharedContext, ctxAttribs);
        if (_eglContext == EGL_NO_CONTEXT) {
            NSLog(@"EAGL create egl context failed");
        }
        
        _sharegroup = sharegroup;
        if (!_sharegroup) {
            _sharegroup = [[EAGLSharegroup alloc] initWithAPI:api];
            _sharegroup.context = self;
        }
        _debugLabel = sharegroup.debugLabel;
    }
    return self;
}

- (id)initWithAPI:(EAGLRenderingAPI)api eglContext:(EGLContext)ctx eglSurface:(EGLSurface)surface sharegroup:(EAGLSharegroup *)sharegroup
{
    self = [super init];
    if (self) {
        _eglDisplay = eglGetCurrentDisplay();
        if (_eglDisplay == EGL_NO_DISPLAY) {
            _eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
        }
        
        _eglContext = ctx;
        _eglSurface = surface;
        _sharegroup = sharegroup;
        if (!_sharegroup) {
            _sharegroup = [[EAGLSharegroup alloc] initWithAPI:api];
            _sharegroup.context = self;
        }
        _debugLabel = sharegroup.debugLabel;
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (_eglContext != EGL_NO_CONTEXT) {
        eglDestroyContext(_eglDisplay, _eglContext);
    }
    
    if (_eglSurface != EGL_NO_SURFACE) {
        eglDestroySurface(_eglDisplay, _eglSurface);
    }
}

@end

