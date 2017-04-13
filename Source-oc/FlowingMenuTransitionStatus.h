//
//  FlowingMenuTransitionStatus.h
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 The FlowingMenuTransitionStatus object aims to make the transition manager
 testable by providing a concevient way to access the
 `UIViewControllerContextTransitioning` `transitionWasCancelled` method.
 */
@interface FlowingMenuTransitionStatus : NSObject

@property (readonly,nonatomic) id<UIViewControllerContextTransitioning> context;
 /// Initializer for testing purpose.
-(instancetype)initWithCancelledOrNot:(BOOL)cancelled;

/// Initializer for running purpose.
- (instancetype)initWithContext:(id<UIViewControllerContextTransitioning>)context;

/**
 Returns a Boolean value indicating whether the transition was canceled.
 
 true if the transition was canceled or false if it is ongoing or finished
 normally.
 
 - returns: true if the transition was canceled or NO if it is ongoing or
 finished normally.
 */
- (BOOL)transitionWasCancelled;

@end
