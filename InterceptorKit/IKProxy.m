//
//  IKProxy.m
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKProxy.h"

@interface IKProxy ()
{
	id _target;
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
	return self;
}

- (BOOL)isKindOfClass:(Class)aClass;
{
    return [_target isKindOfClass:aClass];
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

@end
