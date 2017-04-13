//
//  FlowingMenuTransitionManager.h
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectPoint.h"
#import "FlowingMenuTransitionStatus.h"
#import "ToViewControllerNeedsConform.h"
#import "FromViewControllerNeedsConform.h"

/// Defines the animation mode of the transition.
typedef NS_ENUM(NSInteger, AnimationMode){
    AnimationModePresentation,
    AnimationModeDismissal
};
/**
 The `FlowingMenuTransitionManager` is a concrete subclass of
 `UIPercentDrivenInteractiveTransition` which aims to drive the transition between
 two views by providing an flowing/elastic and bouncing animation effect.
 
 You must adopt the `FlowingMenuDelegate` if you want to make the transition
 interactive.
 */
@interface FlowingMenuTransitionManager : UIPercentDrivenInteractiveTransition<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

/**
 The delegate for the flowing transition manager.
 
 The delegate must adopt the `FlowingMenuDelegate` protocol and implement the
 required methods to manage the interactive animations.
 */
@property(weak, nonatomic) id<FromViewControllerNeedsConform>fromVCDelegate;
@property(weak, nonatomic) id<ToViewControllerNeedsConform>toVCDelegate;
@property(nonatomic) AnimationMode animationMode;

+(instancetype)manager;

-(void)setInteractivePresentationView:(UIView *)view;

-(void)view:(UIView *)otherView presentMenuView:(UIView *)menuView containerView:(UIView *)containerView status:(FlowingMenuTransitionStatus *)status duration:(NSTimeInterval)duration completion:(void (^)())completion;

-(void)view:(UIView *)otherView dismissMenuView:(UIView *)menuView containerView:(UIView *)containerView status:(FlowingMenuTransitionStatus *)status duration:(NSTimeInterval)duration completion:(void (^)())completion;

@end
