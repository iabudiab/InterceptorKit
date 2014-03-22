//
//  IntercetptorKitTypes.h
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

typedef enum
{
    IKInterceptionModePreInvoke		= 1 << 0,
    IKInterceptionModePostInvoke	= 1 << 1,
    IKInterceptionModeConditional	= 1 << 2,
	IKInterceptionModeAbortInvoke	= 1 << 3
} IKInterceptionMode;

typedef BOOL (^ IKInterceptionAction) (id interceptedTarget, SEL interceptedSelector);
typedef BOOL (^ IKInterceptionCondition) (id intercerptedTarget, SEL interceptedSelector);
typedef BOOL (^ IKArgumentsInterceptionAction) (id interceptedTarget, SEL interceptedSelector, NSMutableArray *argumentsList);
