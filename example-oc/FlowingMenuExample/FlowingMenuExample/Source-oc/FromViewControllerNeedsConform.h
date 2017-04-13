//
//  FromViewControllerNeedsConform.h
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/12.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FromViewControllerNeedsConform <NSObject>

@optional
/**
 Called by the flowing menu transition manager when it needs to display the
 menu.
 
 - parameter menuView: The menu view which will be displayed.
 - returns: The width of the menu view. Outside the menu view a black overlay
 will be displayed.
 */
-(CGFloat)widthOfMenuView:(UIView *)menuView;


/**
 Asks the delegate the color of the shape drawn during an interactive
 transition.
 
 - returns: The shape color. If nil it will use the menu background color and
 if menu has no background color, the shape will be black.
 */
-(UIColor *)colorOfElasticShapeInFlowingMenu:(UIView *)menuView;

/**
 Called by the flowing menu transition manager when the interactive transition
 begins its presentation. You should implement this methods to present your
 menu view.
 
 - parameter flowingMenu: The flowing menu transition manager which needs
 present the menu.
 */
- (void)flowingMenuNeedsPresentMenu;

@end
