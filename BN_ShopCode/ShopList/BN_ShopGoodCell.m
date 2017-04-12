//
//  BN_ShopGoodCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realLeadingToFrontTrailing;

@end

@implementation BN_ShopGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumbnailImgView.backgroundColor = ColorLine;
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font10;
    self.realLabel.textColor = ColorLightGray;
    self.realLabel.font = Font8;
    self.realLabel.text = nil;
    self.additionalLabel.textColor = ColorLightGray;
    self.additionalLabel.font = Font8;
}

- (void)typeFace {
    self.frontLabel.textColor = ColorBlack;
    self.frontLabel.font = Font10;
    self.realLeadingToFrontTrailing.constant = 7.0f;
}

- (void)typeFace0 {
    self.frontLabel.textColor = ColorBtnYellow;
    self.frontLabel.font = Font12;
    self.realLeadingToFrontTrailing.constant = 3.0f;
}

- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title front:(NSAttributedString *)front real:(NSString *)real additional:(NSString *)additional {
    [self.thumbnailImgView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:nil];
    self.titleLabel.text = title;
    self.frontLabel.text = real;
    self.realLabel.attributedText = front;
    self.additionalLabel.text = additional;
}

@end
