//
//  IKMethodInjector.m
//  InterceptorKit
//
//  Created by Iska on 02/04/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "IKMethodInjector.h"
#import <objc/runtime.h>
#import "IKMethod.h"

@interface IKMethodInjector ()
{
	NSMutableDictionary *_methodsCache;
}

@end

@implementation IKMethodInjector

#pragma mark - Lifecycle

+ (instancetype)sharedInjector
{
	static IKMethodInjector *singleton = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [[self alloc] init];
	});
	return singleton;
}

- (id)init
{
	self = [super init];
	if (self) {
		_methodsCache = [NSMutableDictionary new];
	}
	return self;
}

#pragma mark - Injection

- (void)interceptClass:(Class)aClass
	 byInjectingAction:(IKArgumentsInterceptionAction)action
  withInterceptionMode:(IKInterceptionMode)mode
		   forSelector:(SEL)selector
{
	Method nativeMethoType = class_getInstanceMethod(aClass, selector);
	IKMethod *method = [IKMethod methodWithObjcType:nativeMethoType];

	IMP injectedBlockImp = imp_implementationWithBlock( ^ id (id _self) {
		NSLog(@"Inside Block IMP");
		action(_self, selector, nil);
		return [method invokeOriginalWithSelfPointer:_self];
	});

	[method setImplementation:injectedBlockImp];
}

- (void)resetSelector:(SEL)selector forClass:(Class)aClass
{

}

@end
