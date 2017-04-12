//
//  V_LineLayer.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "V_LineLayer.h"
#import "BN_ShopHeader.h"

@interface V_LineLayer ()
{
    UIColor *strokeColor;
    CGFloat lineTHWidth;//线的厚度
    CGFloat vX;//v的开始位置
    CGFloat vWidth;//v的宽度
    CGFloat vHeight;//v的高度
    V_Line_Direction vDirection;//箭头的方向
    
}
@end

@implementation V_LineLayer
- (id)init
{
    if (self = [super init])
    {
        strokeColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f];
        lineTHWidth = 0.5f;
        vWidth = 14.0f;
        vHeight = 6.0f;
        vX = 0.0f;
        vDirection = V_LINE_DIRECTION_UP;
        
    }
    return self;
}

- (void)v_LineWith:(CGRect)frame
{
    [self setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置线颜色为blackColor
    [self setStrokeColor:[strokeColor CGColor]];
    // 设置线的厚度
    [self setLineWidth:lineTHWidth];
    [self setLineJoin:kCALineJoinRound];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, frame.origin.x, frame.origin.y);//代表初始坐标的x，y
    CGFloat offsetY = (vDirection == V_LINE_DIRECTION_UP) ? -vHeight : vHeight;
    if (vWidth > 0.0) {
        CGPathAddLineToPoint(path, NULL, frame.origin.x+vX, frame.origin.y);
        CGPathAddLineToPoint(path, NULL, frame.origin.x+vX+vWidth/2, frame.origin.y+offsetY);
        CGPathAddLineToPoint(path, NULL, frame.origin.x+vX+vWidth, frame.origin.y);
    }
    CGPathAddLineToPoint(path, NULL, frame.origin.x+CGRectGetWidth(frame), frame.origin.y);//代表末尾坐标的x，y
    
    [self setPath:path];
    CGPathRelease(path);
}

- (void)setStrokeColorWith:(UIColor *)color
{
    strokeColor = color;
}

- (void)setLineTHWidth:(CGFloat)thWidth
{
    lineTHWidth = thWidth;
}

- (void)setLineWidth:(CGFloat)vX_ vWidth:(CGFloat)vWidth_ vHeight:(CGFloat)vHeight_
{
    vX = vX_;
    vWidth = vWidth_;
    vHeight = vHeight_;
}

- (void)setVDirection:(NSInteger)vDirection_ {
    vDirection = vDirection_;
}

@end
