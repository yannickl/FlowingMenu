//
//  FlowingMenuTransitionStatus.m
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import "FlowingMenuTransitionStatus.h"

@interface FlowingMenuTransitionStatus ()
@property (readonly,nonatomic) BOOL cancelled;
@end
@implementation FlowingMenuTransitionStatus

- (instancetype)initWithCancelledOrNot:(BOOL)cancelled
{
    self = [super init];
    if (self) {
        self->_context = nil;
        self->_cancelled = cancelled;
    }
    return self;
}

- (instancetype)initWithContext:(id<UIViewControllerContextTransitioning>)context
{
    self = [super init];
    if (self) {
        self->_context = context;
        self->_cancelled = NO;
    }
    return self;
}

- (BOOL)transitionWasCancelled
{
    return self.context ? [self.context transitionWasCancelled] : self.cancelled;
}

@end
