//
//  BN_ShopOrderServiceStateView.m
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderServiceStateView.h"

@interface BN_ShopOrderServiceStateView ()
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *serverStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@end

@implementation BN_ShopOrderServiceStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLine.backgroundColor = ColorLine;
    self.bottomLine.backgroundColor = ColorLine;
    self.serverLabel.font = Font12;
    self.serverStateLabel.font = Font12;
    self.serverLabel.textColor = ColorGray;
    self.serverStateLabel.textColor = ColorGray;
}

- (void)updateServerStateFinish {
    self.serverStateLabel.hidden = NO;
    self.serverStateLabel.text = TEXT(@"您的售后申请已处理完成，欢迎您下次继续购物");
    self.serverLabel.hidden = YES;
    self.tagImg.hidden = YES;
}

- (void)updateServerStateIng {
    self.serverStateLabel.hidden = NO;
    self.serverStateLabel.text = TEXT(@"您的售后申请正在处理中，如有任何疑问请联系客服");
    self.serverLabel.hidden = YES;
    self.tagImg.hidden = YES;
}

- (void)updateServerHelp {
    self.serverStateLabel.hidden = YES;
    self.serverLabel.hidden = NO;
    self.tagImg.hidden = NO;
}

- (CGFloat)getViewHeight {
    return 45.0f;
}

@end
