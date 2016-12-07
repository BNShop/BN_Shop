//
//  BN_ShopGoodDetailToolBar.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailToolBar.h"
#import "BGButton.h"

@interface BN_ShopGoodDetailToolBar ()

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet BGButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth;


@end

@implementation BN_ShopGoodDetailToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addToCartButton.normalColor = ColorBtnYellow;
    [self.addToCartButton setTitle:TEXT(@"加入购物车") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.addToCartButton.titleLabel.font = Font12;
    self.numLabel.backgroundColor = ColorBtnYellow;
    self.numLabel.font = Font12;
    self.numLabel.text = @"0";
    self.numLabel.textColor = ColorWhite;
}

- (IBAction)showShopCatr:(id)sender {
    if ([self.delegte respondsToSelector:@selector(goodDetailToolBarClickedWith:)]) {
        [self.delegte goodDetailToolBarClickedWith:sender];
    }
}

- (IBAction)airLine:(id)sender {
    if ([self.delegte respondsToSelector:@selector(goodDetailToolBarClickedWith:)]) {
        [self.delegte goodDetailToolBarClickedWith:sender];
    }
}

- (IBAction)followAction:(id)sender {
    self.followButton.selected = !self.followButton.selected;
    if ([self.delegte respondsToSelector:@selector(goodDetailToolBarClickedWith:)]) {
        [self.delegte goodDetailToolBarClickedWith:sender];
    }
}

- (IBAction)addToCart:(id)sender {
    if ([self.delegte respondsToSelector:@selector(goodDetailToolBarClickedWith:)]) {
        [self.delegte goodDetailToolBarClickedWith:sender];
    }
}

- (void)updateWithSelect:(BOOL)select {
    self.followButton.selected = select;
}

- (void)updateWithAoppositeSelect {
    self.followButton.selected = !self.followButton.selected;
}

- (void)updateAddToCartWithBuyNow {
    self.addToCartButton.normalColor = ColorBtnYellow;
    [self.addToCartButton setNeedsDisplay];
    [self.addToCartButton setTitle:TEXT(@"立即抢购") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
}

- (void)updateAddToCartWithTip {
    self.addToCartButton.normalColor = ColorRed;
    [self.addToCartButton setNeedsDisplay];
    [self.addToCartButton setTitle:TEXT(@"设置提醒") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
}

- (void)updateAddToCartWithTipN {
    self.addToCartButton.normalColor = ColorRed;
    [self.addToCartButton setNeedsDisplay];
    [self.addToCartButton setTitle:TEXT(@"取消提醒") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
}

- (void)updateAddToCartWithFinish {
    self.addToCartButton.normalColor = ColorLightGray;
    [self.addToCartButton setNeedsDisplay];
    [self.addToCartButton setTitle:TEXT(@"抢购结束") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
}

- (void)updateWith:(NSString *)num {
    self.numLabel.text = num;
//    [self.numLabel sizeToFit];
    if ([num intValue] < 10) {
        self.numWidth.constant = 15.0;
    } else {
        self.numWidth.constant = 38.0;
    }
    [self.numLabel updateConstraints];
}

- (CGFloat)getViewHeight {
    return 50.0f;
}


@end

@implementation BN_ShopGoodDetailToolBar (RAC)

- (RACSignal *)rac_shopGoodDetailToolBarClickSignal
{
    self.delegte= self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(goodDetailToolBarClickedWith:) fromProtocol:@protocol(BN_ShopGoodDetailToolBarDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}
@end
