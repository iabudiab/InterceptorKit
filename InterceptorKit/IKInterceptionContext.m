//
//  IKInterceptionContext.m
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKInterceptionContext.h"
#import "NSInvocation+InterceptorKit.h"

@interface IKInterceptionContext ()
{
	SEL _selector;
	IKInterceptionMode _mode;
	IKInterceptionAction _action;
	IKInterceptionCondition _condition;
	IKArgumentsInterceptionAction _argumentsAction;
}

- (BOOL)shouldProceedWithInterception:(NSInvocation *)invocation;

@end

@implementation IKInterceptionContext

#pragma mark - Lifecycle

- (instancetype)initWithSelector:(SEL)selector
							mode:(IKInterceptionMode)mode
					   condition:(IKInterceptionCondition)condition
					   andAction:(IKInterceptionAction)action
{
	self = [super init];
	if(self) {
		_selector = selector;
		_mode = mode;
		_condition = [condition copy];
		_action = [action copy];
	}
	return self;
}

- (instancetype)initWithSelector:(SEL)selector
			 andArgumentsActions:(IKArgumentsInterceptionAction)argumentsAction
{
	self = [super init];
	if(self) {
		_selector = selector;
		_argumentsAction = [argumentsAction copy];
	}
	return self;
}

#pragma mark - Tasks

- (BOOL)performInterceptionWithInvocation:(NSInvocation *)invocation
{
	BOOL abortInvocation = NO;

	if (_selector != invocation.selector) return NO;

	if ([self shouldProceedWithInterception:invocation] == NO) return NO;

	if (_action != nil) {
		abortInvocation = _action(invocation.target, invocation.selector);
	}

	if (_argumentsAction != nil) {
		NSMutableArray *arguments = [invocation argumentsList];
		abortInvocation = _argumentsAction(invocation.target, invocation.selector, arguments);
		[invocation setArguments:arguments];
	}

	return [self isAbortInvokeInterceptor] && abortInvocation;
}

- (BOOL)shouldProceedWithInterception:(NSInvocation *)invocation
{
	if (_condition != nil && [self isConditionalInterceptor]) {
		return _condition(invocation.target, invocation.selector);
	}
	return YES;
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

- (BOOL)isAbortInvokeInterceptor
{
	return (_mode & IKInterceptionModeAbortInvoke) == IKInterceptionModeAbortInvoke;
}

@end
