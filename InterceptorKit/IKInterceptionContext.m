//
//  IKInterceptionContext.m
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKInterceptionContext.h"

@interface IKInterceptionContext ()
{
	IKInterceptionMode _mode;
	IKInterceptionBlock _block;
}
@end

@implementation IKInterceptionContext

#pragma mark - Lifecycle

- (instancetype)initWithMode:(IKInterceptionMode)mode andBlock:(IKInterceptionBlock)block
{
	self = [super init];
	if(self) {
		_mode = mode;
		_block = [block copy];
	}
	return self;
}

#pragma mark - Tasks

- (void)performInterceptionWithInvocation:(NSInvocation *)invocation
{
	_block(invocation.target, invocation.selector);
}

#pragma mark - Attributes

- (BOOL)isPreInvokeInterceptor
{
    return (_mode & IKInterceptionModePreInvoke) == IKInterceptionModePreInvoke;
}

- (BOOL)isPostInvokeInterceptor
{
    return (_mode & IKInterceptionModePostInvoke) == IKInterceptionModePostInvoke;
}

@end
