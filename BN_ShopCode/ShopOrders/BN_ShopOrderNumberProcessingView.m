//
//  BN_ShopOrderNumberProcessingView.m
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderNumberProcessingView.h"
#import "BGButton.h"
#import "UIControl+BlocksKit.h"

@interface BN_ShopOrderNumberProcessingView ()
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet BGButton *precessingBtn;
@end

@implementation BN_ShopOrderNumberProcessingView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelabel.font = Font12;
    self.titlelabel.textColor = ColorGray;
    [self.titlelabel sizeToFit];
    self.bottomLine.backgroundColor = ColorLine;
    
    self.contentLabel.font = Font12;
    self.contentLabel.textColor = ColorLightGray;
    
    [self.precessingBtn.titleLabel setFont:Font12];
    self.precessingBtn.q_CornerRadius = 4.0f;
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

- (void)updateWith:(UIColor *)bgColor q_color:(UIColor *)q_color titleColor:(UIColor *)titleColor title:(NSString *)title {
    if (q_color) {
        self.precessingBtn.q_BorderColor = q_color;
        self.precessingBtn.q_BorderWidth = 1.0;
    } else {
        self.precessingBtn.q_BorderColor = nil;
        self.precessingBtn.q_BorderWidth = 0.0;
    }
    [self.precessingBtn setTitle:title forState:UIControlStateNormal];
    self.precessingBtn.normalColor = bgColor;
    [self.precessingBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
}


- (void)addEventHandler:(void (^)(id sender))handler {
    [self.precessingBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [self.precessingBtn bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
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
