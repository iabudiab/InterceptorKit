//
//  NSInvocation+InterceptorKit.h
//  InterceptorKit
//
//  Created by Iska on 18/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (InterceptorKit)

- (id)argumentAtIndex:(NSInteger)index;
- (NSMutableArray *)argumentsList;
- (void)setArguments:(NSArray *)arguments;

@end
