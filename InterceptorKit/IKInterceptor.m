//
//  IKInterceptor.m
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKInterceptor.h"
#import "IKInterceptionContext.h"

@interface IKInterceptor ()
{
	id _target;
	NSMutableArray *_preInvokeInterceptors;
	NSMutableArray *_postInvokeInterceptors;
}

@end

@implementation IKInterceptor

#pragma mark - Lifecycle

+ (IKInterceptor *)interceptorForTarget:(id)target
{
	return [[IKInterceptor alloc] initWithTarget:target];
}

- (id)initWithTarget:(id)target
{
	_target = target;
	_preInvokeInterceptors = [NSMutableArray new];
	_postInvokeInterceptors = [NSMutableArray new];
	return self;
}

- (BOOL)isKindOfClass:(Class)aClass;
{
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass
{
	return [_target isMemberOfClass:aClass];
}

- (BOOL)isEqual:(id)object
{
	return [_target isEqual:object];
}

#pragma mark - Selector & Protocol

- (BOOL)respondsToSelector:(SEL)aSelector;
{
	return [_target respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol;
{
	return [_target conformsToProtocol:aProtocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
{
    return [_target methodSignatureForSelector:aSelector];
}

#pragma mark - Interception

- (void)interceptSelector:(SEL)selector
			   withAction:(IKInterceptionAction)action
{
	[self interceptSelector:selector
				   withMode:IKInterceptionModePreInvoke | IKInterceptionModePostInvoke
				  andAction:action];
}

- (void)interceptSelector:(SEL)selector
				 withMode:(IKInterceptionMode)mode
				andAction:(IKInterceptionAction)action
{
	[self interceptSelector:selector
				   withMode:mode
				  condition:nil
				  andAction:action];
}

- (void)interceptSelector:(SEL)selector
				 withMode:(IKInterceptionMode)mode
				condition:(IKInterceptionCondition)condition
				andAction:(IKInterceptionAction)action
{
	if (mode == IKInterceptionModeConditional) mode |= IKInterceptionModePreInvoke;

	IKInterceptionContext *context = [[IKInterceptionContext alloc] initWithSelector:selector
																				mode:mode
																		   condition:condition
																		   andAction:action];
	if ([context isPreInvokeInterceptor]) [_preInvokeInterceptors addObject:context];
	if ([context isPostInvokeInterceptor]) [_postInvokeInterceptors addObject:context];
}

- (void)interceptArguemntsForSelector:(SEL)selector
						   withAction:(IKArgumentsInterceptionAction)action
{
	IKInterceptionContext *context = [[IKInterceptionContext alloc] initWithSelector:selector
																 andArgumentsActions:action];
	[_preInvokeInterceptors addObject:context];
}

#pragma mark - Invocation

- (void)forwardInvocation:(NSInvocation *)invocation
{
	if (![self respondsToSelector:invocation.selector]) return;

	invocation.target = _target;

	[_preInvokeInterceptors makeObjectsPerformSelector:@selector(performInterceptionWithInvocation:) withObject:invocation];
	[invocation invoke];
	[_postInvokeInterceptors makeObjectsPerformSelector:@selector(performInterceptionWithInvocation:) withObject:invocation];
}


@end
