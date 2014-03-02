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
} IKInterceptionMode;

typedef void (^ IKInterceptionBlock) (id inteceptedTarget, SEL interceptedSelector);
