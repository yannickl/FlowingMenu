//
//  FlowingMenuTransitionManager.m
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import "FlowingMenuTransitionManager.h"

@interface FlowingMenuTransitionManager ()
@property(strong, nonatomic) CAShapeLayer *shapeLayer;
@property(strong, nonatomic) CAShapeLayer *shapeMaskLayer;
@property(strong, nonatomic) CADisplayLink *displayLink;
@property(nonatomic) BOOL interactive;
@property(strong, nonatomic) NSArray<__kindof ObjectPoint *>*controlPoints;
@property(strong, nonatomic) UIView *bottomView;
@end
@implementation FlowingMenuTransitionManager

+ (instancetype)manager
{
    static FlowingMenuTransitionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.animationMode = AnimationModePresentation;
        self.interactive = NO;
        self.displayLink.paused = YES;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<8; i++) {
            [arr addObject:[ObjectPoint pointWithPoint:CGPointZero]];
        }
        self.controlPoints = arr;
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeMaskLayer = [CAShapeLayer layer];
    }
    return self;
}

-(CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateShapeLayer)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

- (void)view:(UIView *)otherView presentMenuView:(UIView *)menuView containerView:(UIView *)containerView status:(FlowingMenuTransitionStatus *)status duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    UIView *ov = [otherView snapshotViewAfterScreenUpdates:YES];
    if (!ov) {
        return;
    }
    ov.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [containerView addSubview:ov];
    
    // Add the tap gesture
    [self addTapGestureToView:ov];
    

    // Add a mask to the menu to create the bubble effect
    CAShapeLayer *maskLayer       = [CAShapeLayer layer];
    menuView.layer.mask = maskLayer;
    
    CGFloat menuWidth = 0.0;
    if (self.fromVCDelegate && [self.fromVCDelegate respondsToSelector:@selector(widthOfMenuView:)]) {
        menuWidth = [self.fromVCDelegate widthOfMenuView:menuView];
    }else{
        menuWidth = [self widthOfMenuView:menuView];
    }

    //use bottomView to avoid gesture conflict when menview is kindof UIScrollerView
    if ([menuView isKindOfClass:[UIScrollView class]]) {
         self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, menuView.bounds.size.height)];
        [self.bottomView addSubview:menuView];
        [containerView addSubview:self.bottomView];
        [self setInteractiveDismissView:self.bottomView];
    }else{
        [containerView addSubview:menuView];
        [self setInteractiveDismissView:menuView];
    }
    

    CGFloat maxSideSize = MAX(menuView.bounds.size.width, menuView.bounds.size.height);
    
    CGRect beginRect = CGRectMake(1, menuView.bounds.size.height / 2 - 1, 2, 2);
    CGRect middleRect = CGRectMake(-menuWidth, 0, menuWidth * 2, menuView.bounds.size.height);
    
    CGRect endRect = CGRectMake(-maxSideSize, menuView.bounds.size.height / 2 - maxSideSize, maxSideSize * 2, maxSideSize * 2);
    
    
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithRect:menuView.bounds];
    [beginPath appendPath:[[UIBezierPath bezierPathWithOvalInRect:beginRect] bezierPathByReversingPath]];
    
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithRect:menuView.bounds];
    [middlePath appendPath:[[UIBezierPath bezierPathWithOvalInRect:middleRect] bezierPathByReversingPath]];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRect:menuView.bounds];
    [endPath appendPath:[[UIBezierPath bezierPathWithOvalInRect:endRect] bezierPathByReversingPath]];

    
    
    // Defining the menu frame
    CGRect menuFrame     = menuView.frame;
    menuFrame.size.width = menuWidth;
    menuView.frame       = menuFrame;

    // Start the animations
    if(!self.interactive) {
        CAKeyframeAnimation *bubbleAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        bubbleAnim.values = @[(__bridge id )[UIBezierPath bezierPathWithOvalInRect:beginRect].CGPath,(__bridge id )[UIBezierPath bezierPathWithOvalInRect:middleRect].CGPath,(__bridge id )[UIBezierPath bezierPathWithOvalInRect:endRect].CGPath];
        bubbleAnim.keyTimes            = @[@0, @0.4, @1];
        bubbleAnim.duration            = duration;
        bubbleAnim.removedOnCompletion = NO;
        bubbleAnim.fillMode            = kCAFillModeForwards;
        [maskLayer addAnimation:bubbleAnim forKey:@"bubbleAnim"];

    }else {
        // Last control points help us to know the menu height
        self.controlPoints[7].point = CGPointMake(0, menuView.bounds.size.height);
        
        // Be sure there is no animation running
        [self.shapeMaskLayer removeAllAnimations];
        
        // Retrieve the shape color
        UIColor *shapeColor = nil;
        if (self.fromVCDelegate && [self.fromVCDelegate respondsToSelector:@selector(colorOfElasticShapeInFlowingMenu:)]) {
            shapeColor = [self.fromVCDelegate colorOfElasticShapeInFlowingMenu:menuView];
        }else{
            shapeColor = [self colorOfElasticShapeInFlowingMenu:menuView];
        }
        
        if (!shapeColor) {
            shapeColor = menuView.backgroundColor ?: [UIColor blackColor];
        }
        
        self.shapeMaskLayer.path = [UIBezierPath bezierPathWithRect:ov.bounds].CGPath;
        self.shapeLayer.actions = @{@"position" : [NSNull null], @"bounds" : [NSNull null], @"path" : [NSNull null]};
        self.shapeLayer.backgroundColor = shapeColor.CGColor;
        self.shapeLayer.fillColor       = shapeColor.CGColor;
        
        // Add the mask to create the bubble effect
        self.shapeLayer.mask = self.shapeMaskLayer;

        
        // Add the shape layer to container view
        [containerView.layer addSublayer:self.shapeLayer];
    }
    
    containerView.userInteractionEnabled = NO;

    [UIView animateWithDuration:duration animations:^{
        menuView.frame     = CGRectMake(0, menuFrame.origin.y, menuFrame.size.width, menuFrame.size.height);
        otherView.alpha    = 0;
        ov.alpha           = 0.4;
       
    } completion:^(BOOL finished) {
        
        if (self.interactive && ![status transitionWasCancelled]) {
            self.interactive = NO;

            CAKeyframeAnimation *bubbleAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            bubbleAnim.values = @[(__bridge id )[UIBezierPath bezierPathWithOvalInRect:beginRect].CGPath,(__bridge id )[UIBezierPath bezierPathWithOvalInRect:middleRect].CGPath,(__bridge id )[UIBezierPath bezierPathWithOvalInRect:endRect].CGPath];
            bubbleAnim.keyTimes            = @[@0, @0.4, @1];
            bubbleAnim.duration            = duration;
            bubbleAnim.removedOnCompletion = NO;
            bubbleAnim.fillMode            = kCAFillModeForwards;
            [maskLayer addAnimation:bubbleAnim forKey:@"bubbleAnim"];
        
        
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            anim.values              = @[(__bridge id )beginPath.CGPath,(__bridge id )middlePath.CGPath,(__bridge id )endPath.CGPath];
            anim.keyTimes            = @[@0, @0.4, @1];
            anim.duration            = duration;
            anim.removedOnCompletion = NO;
            anim.fillMode            = kCAFillModeForwards;
            [self.shapeMaskLayer addAnimation:anim forKey:@"bubbleAnim"];
        
            for (ObjectPoint *p in self.controlPoints) {
                p.x = menuWidth;
            }
    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                for (ObjectPoint *p in self.controlPoints) {
                                    p.x = menuWidth;
                                }
                            } completion:^(BOOL finished) {
                                [self.shapeLayer removeFromSuperlayer];
                                containerView.userInteractionEnabled = YES;
                
                                menuView.layer.mask = nil;
                                self.displayLink.paused = YES;
                                completion();
                            }];
            });
        }else {
            menuView.layer.mask = nil;
            self.displayLink.paused = YES;

            containerView.userInteractionEnabled = YES;
            completion();
        }
    }];
}

- (void)view:(UIView *)otherView dismissMenuView:(UIView *)menuView containerView:(UIView *)containerView status:(FlowingMenuTransitionStatus *)status duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    otherView.frame = containerView.bounds;
    UIView *ov      = [otherView snapshotViewAfterScreenUpdates:YES];
    CGRect menuFrame = menuView.frame;
    
    [containerView addSubview:otherView];
    [containerView addSubview:ov];
    [containerView addSubview:menuView];
    
    otherView.alpha = 0;
    ov.alpha        = 0.4;
    

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        menuView.frame     = CGRectMake(-menuFrame.size.width, menuFrame.origin.y, menuFrame.size.width, menuFrame.size.height);
        otherView.alpha    = 1;
        ov.alpha           = 1;
    } completion:^(BOOL finished) {
        
      BOOL canceled = [status.context transitionWasCancelled];
        
        if (!canceled) {
            [self.bottomView removeFromSuperview];
        }else{
            [menuView removeFromSuperview];
            [ov removeFromSuperview];
            ov.frame = containerView.bounds;;
            [self.bottomView addSubview:menuView];
            [containerView insertSubview:self.bottomView aboveSubview:ov];
        }
        
        completion();
    }];
}

#pragma mark - private 

- (void)updateShapeLayer {
    self.shapeLayer.path = [self currentPath];
}

- (CGPathRef)currentPath{
    UIBezierPath *bezierPath = [UIBezierPath new];
    
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(self.controlPoints[0].point.x, 0)];
    [bezierPath addCurveToPoint:self.controlPoints[2].point controlPoint1:self.controlPoints[0].point controlPoint2:self.controlPoints[1].point];
    [bezierPath addCurveToPoint:self.controlPoints[4].point controlPoint1:self.controlPoints[3].point controlPoint2:self.controlPoints[4].point];
    [bezierPath addCurveToPoint:self.controlPoints[6].point controlPoint1:self.controlPoints[4].point controlPoint2:self.controlPoints[5].point];
    [bezierPath addLineToPoint:CGPointMake(0, self.controlPoints[7].point.y)];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

- (void)moveControlPointsToPoint:(CGPoint )position waveWidth:(CGFloat)waveWidth
{
    CGFloat height     = self.controlPoints[7].point.y;
    
    CGFloat minTopY    = MIN((position.y - height / 2) * 0.28, 0);
    CGFloat maxBottomY = MAX(height + (position.y - height / 2) * 0.28, height);
    
    CGFloat leftPartWidth  = position.y - minTopY;
    CGFloat rightPartWidth = maxBottomY - position.y;
    
    self.controlPoints[0].point = CGPointMake(position.x, minTopY);
    self.controlPoints[1].point = CGPointMake(position.x, minTopY + leftPartWidth * 0.44);
    self.controlPoints[2].point = CGPointMake(position.x + waveWidth * 0.64, minTopY + leftPartWidth * 0.71);
    self.controlPoints[3].point = CGPointMake(position.x + waveWidth * 1.36, position.y);
    self.controlPoints[4].point = CGPointMake(position.x + waveWidth * 0.64, maxBottomY - rightPartWidth * 0.71);
    self.controlPoints[5].point = CGPointMake(position.x, maxBottomY - (rightPartWidth * 0.44));
    self.controlPoints[6].point = CGPointMake(position.x, height);
    
}

#pragma mark - FlowingMenuTransitionManager + UIGestureRecognizer

- (void)addTapGestureToView:(UIView*)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapGesture];
}

-(void)setInteractiveDismissView:(UIView *)view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToDismissAction:)];
    panGesture.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:panGesture];
}

-(void)setInteractivePresentationView:(UIView *)view{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panToPresentAction:)];
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:screenEdgePanGesture];
}

-(void)tapToDismissAction:(UITapGestureRecognizer *)tapGesture {
    if (self.toVCDelegate && [self.toVCDelegate respondsToSelector:@selector(flowingMenuNeedsDismissMenu)]) {
        [self.toVCDelegate flowingMenuNeedsDismissMenu];
    }
}

-(void)panToDismissAction:(UIPanGestureRecognizer *)panGesture {
    UIView *view = panGesture.view;
    
    CGFloat menuWidth = 0.0;
    if (self.fromVCDelegate && [self.fromVCDelegate respondsToSelector:@selector(widthOfMenuView:)]) {
        menuWidth = [self.fromVCDelegate widthOfMenuView:view];
    }else{
        menuWidth = [self widthOfMenuView:view];
    }
    CGPoint translation = [panGesture translationInView:view];
  
    CGFloat percentage = MIN(MAX(translation.x / menuWidth * -1, 0), 1);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.interactive = YES;
        // Asking the delegate the dismiss the menu
        if (self.toVCDelegate && [self.toVCDelegate respondsToSelector:@selector(flowingMenuNeedsDismissMenu)]) {
            [self.toVCDelegate flowingMenuNeedsDismissMenu];
        }
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self updateInteractiveTransition:percentage];
    }else if(panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded) {
        self.interactive = NO;
        if (percentage > 0.2) {
            [self finishInteractiveTransition];
        }else{
            [self cancelInteractiveTransition];
        }
    }
}

-(void)panToPresentAction:(UIScreenEdgePanGestureRecognizer *)panGesture {
    UIView *view = panGesture.view;
    CGPoint translation = [panGesture translationInView:view];
    CGFloat yLocation  = [panGesture locationInView:view].y;
    
    CGFloat menuWidth = 0.0;
    if (self.fromVCDelegate && [self.fromVCDelegate respondsToSelector:@selector(widthOfMenuView:)]) {
        menuWidth = [self.fromVCDelegate widthOfMenuView:view];
    }else{
        menuWidth = [self widthOfMenuView:view];
    }

    CGFloat percentage = MIN(MAX(translation.x / (menuWidth/2), 0), 1);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.interactive = YES;
        // Asking the delegate the present the menu
        if (self.fromVCDelegate && [self.fromVCDelegate respondsToSelector:@selector(flowingMenuNeedsPresentMenu)]) {
            [self.fromVCDelegate flowingMenuNeedsPresentMenu];
        }
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self updateInteractiveTransition:percentage];
        
        CGFloat waveWidth = translation.x * 0.9;
        CGFloat left      = waveWidth * 0.1;
        
        // Update the control points
        [self moveControlPointsToPoint:CGPointMake(left, yLocation) waveWidth:waveWidth];
        [self updateShapeLayer];
    }else /*if(panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded)*/{
        self.displayLink.paused = NO;
        if( percentage < 1 ){
            self.interactive = NO;
            [self moveControlPointsToPoint:CGPointMake(0, yLocation) waveWidth:0];
            [self cancelInteractiveTransition];
        }
        else {
            [self finishInteractiveTransition];
        }
        
    }
}


#pragma mark - FlowingMenuDelegate
                          
- (CGFloat)widthOfMenuView:(UIView *)menuView
{
    return menuView.bounds.size.width * 2 / 3;
}

-(UIColor *)colorOfElasticShapeInFlowingMenu:(UIView *)menuView
{
    return [UIColor cyanColor];
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.animationMode = AnimationModePresentation;
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animationMode = AnimationModeDismissal;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    self.animationMode = AnimationModePresentation;
    return self.interactive ? self : nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    self.animationMode = AnimationModeDismissal;
    return self.interactive ? self : nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *menuView      = (self.animationMode == AnimationModePresentation) ? toVC.view : fromVC.view;
    UIView *otherView     = (self.animationMode == AnimationModePresentation) ? fromVC.view : toVC.view; ;
    
    FlowingMenuTransitionStatus *status = [[FlowingMenuTransitionStatus alloc] initWithContext:transitionContext];
    
    if (self.animationMode == AnimationModePresentation) {
        [self view:otherView presentMenuView:menuView containerView:containerView status:status duration:[self transitionDuration:transitionContext] completion:^{
            BOOL canceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!canceled];
            
            if (!canceled) {
                [[UIApplication sharedApplication].keyWindow insertSubview:fromVC.view atIndex:0];
            }
        }];
    }else{
        [self view:otherView dismissMenuView:menuView containerView:containerView status:status duration:[self transitionDuration:transitionContext] completion:^{
            BOOL canceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!canceled];
            
            if (!canceled) {
                [[UIApplication sharedApplication].keyWindow insertSubview:fromVC.view atIndex:0];
            }
        }];
    }
}
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return  self.interactive ? 0.6 : 0.25;
}

@end
