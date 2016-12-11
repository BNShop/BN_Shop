//
//  BN_ShopOrderNumberView.m
//  BN_Shop
// 订单各种小状态
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderNumberView.h"
#import "BN_ShopHeader.h"

@interface BN_ShopOrderNumberView ()
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation BN_ShopOrderNumberView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelabel.font = Font12;
    self.titlelabel.textColor = ColorGray;
    [self.titlelabel sizeToFit];
    self.bottomLine.backgroundColor = ColorLine;
    
    self.contentLabel.font = Font12;
    self.contentLabel.textColor = ColorLightGray;
}

- (void)updateWith:(NSString *)title content:(NSString *)content {
    self.titlelabel.text = title;
    self.contentLabel.text = content;
    [self.titlelabel sizeToFit];
    [self.contentLabel sizeToFit];
}

- (void)udatewithContentAttr:(NSAttributedString *)content {
    self.titlelabel.text = @" ";
    self.contentLabel.attributedText = content;
    [self.titlelabel sizeToFit];
    [self.contentLabel sizeToFit];
}

- (void)updateWith:(UIFont *)font contentColor:(UIColor *)color {
    self.contentLabel.textColor = color;
    self.contentLabel.font = font;
}

- (void)updateOrderStateContent {
    [self updateWith:Font10 contentColor:ColorBtnYellow];
}

- (void)updateOrderPriceContent {
    [self updateWith:Font13 contentColor:ColorRed];
}

- (CGFloat)getViewHeight {
    return 45.0f;
}


@end
