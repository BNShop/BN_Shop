//
//  BN_ShopGoodDetaiNormalStateView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetaiNormalStateView.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetaiNormalStateView ()
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontPrice;



@end

@implementation BN_ShopGoodDetaiNormalStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.realPriceLabel.textColor = ColorBlack;
    self.realPriceLabel.font = Font16;
    [self.realPriceLabel sizeToFit];
    self.frontPrice.textColor = ColorLightGray;
    self.frontPrice.font = Font8;
    [self.frontPrice sizeToFit];
}

- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice {
    self.realPriceLabel.text = realPrice;
    self.frontPrice.attributedText = frontPrice;
}

- (CGFloat)getViewHeight {
    return 54.0f;
}

@end
