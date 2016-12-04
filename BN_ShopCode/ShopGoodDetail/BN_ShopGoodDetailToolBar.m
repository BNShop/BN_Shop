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


@end

@implementation BN_ShopGoodDetailToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addToCartButton.normalColor = ColorBtnYellow;
    [self.addToCartButton setTitle:TEXT(@"加入购物车") forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.addToCartButton.titleLabel.font = Font12;
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
