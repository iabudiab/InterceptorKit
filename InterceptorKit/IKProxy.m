//
//  IKProxy.m
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKProxy.h"
#import "IKInterceptionContext.h"

@interface IKProxy ()
{
	id _target;
	NSMutableArray *_preInvokeInterceptors;
	NSMutableArray *_postInvokeInterceptors;
}

@end

@implementation IKProxy

#pragma mark - Lifecycle

+ (IKProxy *)interceptorForTarget:(id)target
{
	return [[IKProxy alloc] initWithTarget:target];
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

- (void)interceptSelector:(SEL)selector withMode:(IKInterceptionMode)mode andBlock:(IKInterceptionBlock)block
{
	IKInterceptionContext *context = [[IKInterceptionContext alloc] initWithMode:mode
																	   andBlock:block];
	if ([context isPreInvokeInterceptor]) [_preInvokeInterceptors addObject:context];
	if ([context isPostInvokeInterceptor]) [_postInvokeInterceptors addObject:context];
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
