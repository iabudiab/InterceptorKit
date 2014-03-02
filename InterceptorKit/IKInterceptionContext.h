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

- (instancetype)initWithMode:(IKInterceptionMode)mode andBlock:(IKInterceptionBlock)block;

- (void)performInterceptionWithInvocation:(NSInvocation *)invocation;

- (BOOL)isPreInvokeInterceptor;
- (BOOL)isPostInvokeInterceptor;

@end
