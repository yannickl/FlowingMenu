//
//  MyPoint.m
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/11.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import "ObjectPoint.h"


@implementation ObjectPoint

+(ObjectPoint *)pointWithPoint:(CGPoint)point
{
    return [[self alloc] initWithPoint:point];
}

-(ObjectPoint *)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        self.point = point;
    }
    return self;
}

+(ObjectPoint *)pointWithX:(CGFloat)x Y:(CGFloat)y
{
    return [[self alloc] initWithX:x Y:y];
}

- (ObjectPoint *)initWithX:(CGFloat)x Y:(CGFloat)y
{
    self = [super init];
    if (self) {
        self.point = CGPointMake(x, y);
    }
    return self;
}

-(CGFloat)x
{
    return self.point.x;
}

- (void)setX:(CGFloat)x
{
    CGPoint tmpPoint = CGPointMake(x, self.point.y);
    self.point = tmpPoint;
}

-(CGFloat)y
{
    return self.point.y;
}

-(void)setY:(CGFloat)y
{
    CGPoint tmpPoint = CGPointMake(self.point.y, y);
    self.point = tmpPoint;
}

@end
