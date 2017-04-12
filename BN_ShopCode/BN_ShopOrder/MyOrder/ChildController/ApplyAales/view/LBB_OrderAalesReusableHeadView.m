//
//  LBB_OrderAalesReusableHeadView.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderAalesReusableHeadView.h"
#import "BN_ShopHeader.h"

@implementation LBB_OrderAalesReusableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = ColorBackground;
    self.lineView.backgroundColor = ColorLine;
    self.textLabel.font = Font15;
    self.tipLabel.font = Font14;
    self.tipLabel.textColor = ColorLightGray;
    self.tipLabel.text = @"(可不填)";
    self.tipLabel.hidden = YES;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.tipLabel.hidden = YES;
    self.textLabel.text = nil;
}
@end
