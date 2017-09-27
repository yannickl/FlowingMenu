//
//  MyPoint.h
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGPoint point;

+(ObjectPoint *)pointWithPoint:(CGPoint)point;
-(ObjectPoint *)initWithPoint:(CGPoint)point;
+(ObjectPoint *)pointWithX:(CGFloat)x Y:(CGFloat)y;
-(ObjectPoint *)initWithX:(CGFloat)x Y:(CGFloat)y;

@end
