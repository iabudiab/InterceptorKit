//
//  IntercetptorKitTypes.h
//  InterceptorKit
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

typedef enum
{
    IKInterceptionModePreInvoke      = 1 << 0,
    IKInterceptionModePostInvoke     = 1 << 1,
    IKInterceptionModeConditional    = 1 << 2
} IKInterceptionMode;

typedef void (^ IKInterceptionAction) (id inteceptedTarget, SEL interceptedSelector);
typedef BOOL (^ IKInterceptionCondition) (id inteceptedTarget, SEL interceptedSelector);
