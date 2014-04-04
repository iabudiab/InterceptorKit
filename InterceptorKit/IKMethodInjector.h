//
//  IKMethodInjector.h
//  InterceptorKit
//
//  Created by Iska on 02/04/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntercetptorKitTypes.h"

@interface IKMethodInjector : NSObject

+ (instancetype)sharedInjector;

- (void)interceptClass:(Class)aClass
	 byInjectingAction:(IKArgumentsInterceptionAction)action
  withInterceptionMode:(IKInterceptionMode)mode
		   forSelector:(SEL)selector;
- (void)resetSelector:(SEL)selector forClass:(Class)aClass;

@end
