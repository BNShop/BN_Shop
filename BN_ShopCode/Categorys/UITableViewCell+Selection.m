//
//  UITableViewCell+Selection.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "UITableViewCell+Selection.h"

@implementation UITableViewCell (Selection)
- (void)setSelectionColor:(UIColor *)color
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = color;
}

- (void)clearSelectionColor
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
