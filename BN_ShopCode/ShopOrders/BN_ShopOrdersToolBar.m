//
//  BN_ShopOrdersToolBar.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersToolBar.h"
#import "BGButton.h"
#import "UIControl+BlocksKit.h"

@interface BN_ShopOrdersToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet BGButton *placeAnOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *realPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;

@end

@implementation BN_ShopOrdersToolBar
- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLineView.backgroundColor = ColorLine;
    self.placeAnOrderButton.normalColor = ColorBtnYellow;
    [self.placeAnOrderButton setTitle:TEXT(@"立即下单") forState:UIControlStateNormal];
    [self.placeAnOrderButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.placeAnOrderButton.titleLabel.font = Font15;
    self.realPriceTitleLabel.font = Font12;
    self.realPriceTitleLabel.textColor = ColorBlack;
    self.realPriceLabel.font = Font12;
    self.realPriceLabel.textColor = ColorRed;
    self.realPriceTitleLabel.text = @"实付款：";
    [self.realPriceTitleLabel sizeToFit];
    self.realPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", 0.0];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)placeAnOrderWith:(void (^)(id sender))handler {
    [self.placeAnOrderButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateWith:(NSString *)realPrice {
    self.realPriceLabel.text = realPrice;
}

- (CGFloat)getViewHeight {
    return 40.0f;
}
@end
