//
//  LBB_OrderAalesPictureViewCell.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderAalesPictureViewCell.h"

@implementation LBB_OrderAalesPictureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.backgroundColor = ColorLine;
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
}

@end
