//
//  IKInterceptor.h
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntercetptorKitTypes.h"

@interface IKInterceptor : NSProxy

+ (IKInterceptor *)interceptorForTarget:(id)target;

- (id)initWithTarget:(id)target;

- (void)interceptSelector:(SEL)selector
			   withAction:(IKInterceptionAction)action;
- (void)interceptSelector:(SEL)selector
				 withMode:(IKInterceptionMode)mode
				andAction:(IKInterceptionAction)action;
- (void)interceptSelector:(SEL)selector
				 withMode:(IKInterceptionMode)mode
				condition:(IKInterceptionCondition)condition
				andAction:(IKInterceptionAction)action;

@end
