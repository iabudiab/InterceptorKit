//
//  IKProxy.h
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKProxy : NSProxy

+ (IKProxy *)interceptorForTarget:(id)target;

- (id)initWithTarget:(id)target;

@end
