//
//  BGButton.m
//  QBFlatButtonDemo
//
//  Created by Liya on 16/1/11.
//  Copyright © 2016年 Katsuma Tanaka. All rights reserved.
//

#import "BGButton.h"

@interface BGButton ()



@end

@implementation BGButton

- (void)setHighlighted:(BOOL)value
{
    [super setHighlighted:value];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)value
{
    [super setSelected:value];
    
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGSize size = self.bounds.size;
    
    // Create surface image
    CGRect surfaceRect = CGRectMake(0, 0, size.width, size.height);
    if (!self.enabled)
    {
        [[_normalColor colorWithAlphaComponent:0.5] set];
        [self drawRoundedRect:surfaceRect radius:self.radius context:UIGraphicsGetCurrentContext()];
    }
    else if (self.state != UIControlStateHighlighted && self.state != UIControlStateSelected)
    {
        [_normalColor set];
        [self drawRoundedRect:surfaceRect radius:self.radius context:UIGraphicsGetCurrentContext()];
    }
    else
    {
        UIColor *hightColor = _hightedColor;
        if (!hightColor)
        {
            hightColor = [_normalColor colorWithAlphaComponent:0.8f];
        }
        
        [hightColor set];
        [self drawRoundedRect:surfaceRect radius:self.radius context:UIGraphicsGetCurrentContext()];
    }
}


- (void)drawRoundedRect:(CGRect)rect radius:(CGFloat)radius context:(CGContextRef)context
{
    rect.origin.x += 0.5;
    rect.origin.y += 0.5;
    rect.size.width -= 1.0;
    rect.size.height -= 1.0;
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat x = self.bounds.origin.x - self.enlargeInset.left;
    CGFloat y = self.bounds.origin.y - self.enlargeInset.top;
    CGFloat width = self.bounds.size.width + self.enlargeInset.right + self.enlargeInset.left;
    CGFloat height = self.bounds.size.height + self.enlargeInset.bottom + self.enlargeInset.top;
    CGRect rect = CGRectMake(x, y, width, height);
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }
    BOOL result = CGRectContainsPoint(rect, point) && self.hidden == NO ? YES : NO;
    return result;
}

@end
