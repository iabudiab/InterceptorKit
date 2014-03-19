//
//  IKInterceptionContext.h
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntercetptorKitTypes.h"

@interface IKInterceptionContext : NSObject

- (instancetype)initWithMode:(IKInterceptionMode)mode
				   condition:(IKInterceptionCondition)condition
				   andAction:(IKInterceptionAction)action;

- (instancetype)initWithArgumentsActions:(IKArgumentsInterceptionAction)argumentsAction;

- (void)performInterceptionWithInvocation:(NSInvocation *)invocation;

- (BOOL)isPreInvokeInterceptor;
- (BOOL)isPostInvokeInterceptor;
- (BOOL)isConditionalInterceptor;

@end
