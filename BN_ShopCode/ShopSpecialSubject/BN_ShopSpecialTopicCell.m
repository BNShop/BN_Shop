//
//  BN_ShopSpecialTopicCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialTopicCell.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipWidth;

@end

@implementation BN_ShopSpecialTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBlack;
    self.subTitleLabel.font = Font10;
    self.subTitleLabel.textColor = ColorLightGray;
    
    self.tipLabel.font = Font10;
    self.tipLabel.textColor = ColorBtnYellow;
    self.tipLabel.q_BorderColor = ColorBtnYellow;
    self.tipLabel.q_BorderWidth = 1.0f;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)imgUrl title:(NSString *)title subTitle:(NSString *)subTitle tip:(NSString *)tip {
    [self.imgView sd_setImageWithURL:[imgUrl URL] placeholderImage:nil];
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    if (tip.length > 0) {
        self.tipLabel.text = tip;
        [self.tipLabel sizeToFit];
        self.tipWidth.constant = WIDTH(self.tipLabel) + 20;
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
}

@end
