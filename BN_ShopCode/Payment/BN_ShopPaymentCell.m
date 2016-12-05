//
//  BN_ShopPaymentCell.m
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopPaymentCell.h"

@interface BN_ShopPaymentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BN_ShopPaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImgView.q_BorderColor = ColorLine;
    self.iconImgView.q_BorderWidth = 1.0f;
    self.iconImgView.q_CornerRadius = 2.0f;
    
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.font = Font12;
    self.subTitleLabel.textColor = ColorLightGray;
    self.subTitleLabel.font = Font10;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle {
    self.iconImgView.image = IMAGE(iconName);
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

@end
