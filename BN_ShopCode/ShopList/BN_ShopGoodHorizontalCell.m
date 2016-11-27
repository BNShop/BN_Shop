//
//  BN_ShopGoodHorizontalCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodHorizontalCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopGoodHorizontalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopGoodHorizontalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.thumbnailImgView.backgroundColor = ColorLine;
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font12;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    
    self.realLabel.textColor = ColorLightGray;
    self.realLabel.font = Font8;
    self.realLabel.text = nil;
    
    self.additionalLabel.textColor = ColorLightGray;
    self.additionalLabel.font = Font10;
    
    self.frontLabel.textColor = ColorBlack;
    self.frontLabel.font = Font12;
    
    self.bottomLineView.backgroundColor = ColorLine;
    
}


- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title front:(NSAttributedString *)front real:(NSString *)real additional:(NSString *)additional {
    [self.thumbnailImgView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:nil];
    self.titleLabel.text = title;
    self.frontLabel.text = real;
    self.realLabel.attributedText = front;
    self.additionalLabel.text = additional;
}

@end
