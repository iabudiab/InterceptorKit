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
	IKInterceptionAction _action;
	IKInterceptionCondition _condition;
}

@end

@implementation IKInterceptionContext

#pragma mark - Lifecycle

- (instancetype)initWithMode:(IKInterceptionMode)mode
				   condition:(IKInterceptionCondition)condition
				   andAction:(IKInterceptionAction)action
{
	self = [super init];
	if(self) {
		_mode = mode;
		_condition = [condition copy];
		_action = [action copy];
	}
	return self;
}

#pragma mark - Tasks

- (void)performInterceptionWithInvocation:(NSInvocation *)invocation
{
	if ([self isConditionalInterceptor] && _condition != nil) {
		if (_condition(invocation.target, invocation.selector) == NO) return;
	}
	_action(invocation.target, invocation.selector);
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

- (BOOL)isConditionalInterceptor
{
	return (_mode & IKInterceptionModeConditional) == IKInterceptionModeConditional;
}

@end
