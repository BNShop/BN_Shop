//
//  LBB_OrderAalesDescViewCell.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderAalesDescViewCell.h"
#import "BN_ShopHeader.h"

@implementation LBB_OrderAalesDescViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = ColorLine;
    self.textView.font = Font14;
}

@end
