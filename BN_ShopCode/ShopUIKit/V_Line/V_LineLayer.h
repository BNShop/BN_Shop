//
//  V_LineLayer.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, V_Line_Direction) {
    V_LINE_DIRECTION_UP,
    V_LINE_DIRECTION_DOWN,
    
};

@interface V_LineLayer : CAShapeLayer


- (void)setStrokeColorWith:(UIColor *)color;
- (void)setLineTHWidth:(CGFloat)thWidth;
- (void)setLineWidth:(CGFloat)vX_ vWidth:(CGFloat)vWidth_ vHeight:(CGFloat)vHeight_;
- (void)v_LineWith:(CGRect)frame;
- (void)setVDirection:(NSInteger)vDirection_;

@end
