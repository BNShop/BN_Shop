//
//  BN_ShopBannerCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopBannerCell.h"
#import "NSObject+BKBlockObservation.h"

@interface BN_ShopBannerCell ()
@property (weak, nonatomic) IBOutlet UILabel *bannerLabel;

@end

@implementation BN_ShopBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerLabel.textColor = ColorGray;
    self.bannerLabel.font = Font10;
    
    self.q_BorderColor = ColorLine;
    self.q_BorderWidth = 1.0;
    
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [ColorBtnYellow colorWithAlphaComponent:0.1];
    self.selectedBackgroundView.q_BorderColor = ColorBtnYellow;
 
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.isSelected) {
        self.bannerLabel.textColor = ColorBtnYellow;
        self.q_BorderWidth = 0.0;
        self.selectedBackgroundView.q_BorderWidth = 1.0f;
    } else {
        self.bannerLabel.textColor = ColorGray;
        self.q_BorderWidth = 1.0;
        self.selectedBackgroundView.q_BorderWidth = 0.0f;
    }
}

- (void)updateWith:(NSString *)banner {
    self.bannerLabel.text = banner;
}

@end
