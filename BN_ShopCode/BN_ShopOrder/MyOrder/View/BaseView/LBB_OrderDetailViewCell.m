//
//  LBB_OrderDetailViewCell.m
//  adf
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderDetailViewCell.h"
#import "UIImageView+WebCache.h"
#import "BN_ShopHeader.h"

@implementation LBB_OrderDetailViewCell

CGFloat orderCellHeight(LBB_OrderModelDetail* cellInfo)
{
    CGFloat height = 80 + 26.f;
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    NSString *moneyStr = [NSString stringWithFormat:@"￥%@",cellInfo.real_price];
    CGFloat moneyWidth = OrderSizeOfString(moneyStr, CGSizeMake(999, 15), Font15).width;
    if (moneyWidth < 30.f) {
        moneyWidth = 30.f;
    }
    CGSize nameSize = OrderSizeOfString(cellInfo.goods_name, CGSizeMake(mainScreenWidth - 80.f - 55.f - moneyWidth, 9999),Font15);
    CGSize typeSize = OrderSizeOfString(cellInfo.standard,CGSizeMake(mainScreenWidth - 80.f - 55.f - moneyWidth, 9999),Font13);
    
    if ((nameSize.height + typeSize.height + 10.f) > 80.f) {
        height += (nameSize.height + typeSize.height + 10.f) - 80.f;
    }

    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = ColorGray;
    self.typeLabel.textColor = ColorGray;
    self.monneyLabel.textColor = ColorRed;
    self.numLabel.textColor = ColorGray;
    self.lineView.backgroundColor = ColorLine;
    
    self.nameLabel.font = Font15;
    self.typeLabel.font = Font13;
    self.monneyLabel.font = Font15;
    self.numLabel.font = Font15;
    self.imageWidthContraint.constant = 80.f;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imgView.image = nil;
    self.nameLabel.text = @"";
    self.typeLabel.text = @"";
}
 

- (void)setCellInfo:(LBB_OrderModelDetail*)cellInfo
{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectedBackgroundView.backgroundColor = RGB(240, 240, 240);
    self.nameLabel.text = cellInfo.goods_name;
    self.typeLabel.text = cellInfo.standard;
    self.monneyLabel.text = [NSString stringWithFormat:@"￥%@",cellInfo.real_price];
    self.numLabel.text = [NSString stringWithFormat:@"x %@",@(cellInfo.goods_num)];
    if ([cellInfo.pic_url length]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:cellInfo.pic_url] placeholderImage:nil];
    }else{
        self.imgView.image = nil;
    }
    self.accessoryView =  nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
