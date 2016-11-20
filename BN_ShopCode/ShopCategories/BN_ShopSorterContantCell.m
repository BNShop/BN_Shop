//
//  BN_ShopSorterContantCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSorterContantCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopSorterContantCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeadingConstraints;

@end

@implementation BN_ShopSorterContantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font10;
    self.contentIconView.q_BorderColor = ColorLine;
    self.contentIconView.q_BorderWidth = 1.0f;
    
}

- (void)layoutSubviews {
    self.contentIconView.q_CornerRadius = (WIDTH(self)-30) / 2.0;
}

- (void)updateConstraints {
    
    self.iconWidthConstraints.constant = WIDTH(self)-30;
    self.iconLeadingConstraints.constant = 15;
    self.iconTopConstraints.constant = HEIGHT(self) - self.iconWidthConstraints.constant - 16;
    [super updateConstraints];
}

- (void)updateWith:(NSString *)title iconUrl:(NSString *)iconUrl {
    self.titleLabel.text = title;
    [self.contentIconView sd_setImageWithURL:[iconUrl URL] placeholderImage:IMAGE(@"")];
}

@end
