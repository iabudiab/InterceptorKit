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

- (instancetype)initWithSelector:(SEL)selector
							mode:(IKInterceptionMode)mode
					   condition:(IKInterceptionCondition)condition
					   andAction:(IKInterceptionAction)action;

- (instancetype)initWithSelector:(SEL)selector
			 andArgumentsActions:(IKArgumentsInterceptionAction)argumentsAction;

- (BOOL)performInterceptionWithInvocation:(NSInvocation *)invocation;

- (BOOL)isPreInvokeInterceptor;
- (BOOL)isPostInvokeInterceptor;
- (BOOL)isConditionalInterceptor;
- (BOOL)isAbortInvokeInterceptor;

@end
