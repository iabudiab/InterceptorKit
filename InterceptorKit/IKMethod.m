//
//  IKMethod.m
//  InterceptorKit
//
//  Created by Iska on 02/04/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKMethod.h"

@interface IKMethod ()
{
	Method _method;
	SEL _selector;
	IMP _implementation;
	NSString *_typeEncoding;
}

@end

@implementation IKMethod
@synthesize selector = _selector;
@synthesize implementation = _implementation;
@synthesize typeEncoding = _typeEncoding;

#pragma mark - Lifecycle

+ (instancetype)methodWithObjcType:(Method)method
{
	IKMethod *interceptedMethod = [[IKMethod alloc] initWithObjcType:method];
	return interceptedMethod;
}

- (instancetype)initWithObjcType:(Method)method
{
	self = [super init];
	if (self) {
		_method = method;
		_selector = method_getName(method);
		_implementation = method_getImplementation(method);
		_typeEncoding = [[NSString alloc] initWithCString:method_getTypeEncoding(method) encoding:NSUTF8StringEncoding];
	}
	return self;
}

#pragma mark - Reflection

- (void)reset
{
	method_setImplementation(_method, _implementation);
}

- (void)setImplementation:(IMP)implementation
{
	method_setImplementation(_method, implementation);
}

- (id)invokeOriginalWithSelfPointer:(id)selfPointer
{
	return _implementation(selfPointer, _selector);
}

@end
