//
//  ToViewControllerNeedsConform.h
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/12.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToViewControllerNeedsConform <NSObject>
/**
 Called by the flowing menu transition manager when the interactive transition
 begins its dismissal. You should implement this methods to dismiss your menu
 view.
 
 - parameter flowingMenu: The flowing menu transition manager which needs
 dismiss the menu.
 */
-(void)flowingMenuNeedsDismissMenu;

@end
