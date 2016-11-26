//
//  BN_ShopGoodDetailConsultancyHeadView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailConsultancyHeadView.h"
@interface BN_ShopGoodDetailConsultancyHeadView ()
@property (weak, nonatomic) IBOutlet UIView *frameView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BN_ShopGoodDetailConsultancyHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frameView.q_BorderColor = ColorBtnYellow;
    self.frameView.q_BorderWidth = 1.0f;
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBtnYellow;
    [self.titleLabel sizeToFit];
}

- (void)updateWith:(NSString *)title {
    self.titleLabel.text = title;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleLabel sizeToFit];
    });
}

- (CGFloat)getViewHeight {
    return 38.0f;
}
@end
