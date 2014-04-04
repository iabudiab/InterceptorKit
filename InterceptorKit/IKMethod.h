//
//  IKMethod.h
//  InterceptorKit
//
//  Created by Iska on 02/04/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface IKMethod : NSObject

@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) IMP implementation;
@property (nonatomic, readonly) NSString *typeEncoding;

+ (instancetype)methodWithObjcType:(Method)method;

- (instancetype)initWithObjcType:(Method)method;

- (void)reset;
- (void)setImplementation:(IMP)implementation;
- (id)invokeOriginalWithSelfPointer:(id)selfPointer;

@end
