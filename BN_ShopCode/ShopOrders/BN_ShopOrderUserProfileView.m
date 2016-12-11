//
//  BN_ShopOrderUserProfileView.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderUserProfileView.h"
#import "BN_ShopHeader.h"

@interface BN_ShopOrderUserProfileView ()
@property (weak, nonatomic) IBOutlet UILabel *orderUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderUserTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *taggedLabel;
@property (weak, nonatomic) IBOutlet UILabel *provincesLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRView;


@end

@implementation BN_ShopOrderUserProfileView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderUserNameLabel.font = Font12;
    self.orderUserNameLabel.textColor = ColorBlack;
    [self.orderUserNameLabel sizeToFit];
    self.orderUserTelLabel.font = Font12;
    self.orderUserTelLabel.textColor = ColorBlack;
    [self.orderUserTelLabel sizeToFit];
    self.taggedLabel.text = [NSString stringWithFormat:@"  %@  ", TEXT(@"默认")];
    self.taggedLabel.font = Font12;
    self.taggedLabel.textColor = ColorBtnYellow;
    self.taggedLabel.q_BorderColor = ColorBtnYellow;
    self.taggedLabel.q_BorderWidth = 1.0f;
    self.taggedLabel.q_CornerRadius = 8;
    self.taggedLabel.q_MasksToBounds = YES;
    [self.taggedLabel sizeToFit];
    self.provincesLabel.font = Font12;
    self.provincesLabel.textColor = ColorLightGray;
    self.streetLabel.font = Font12;
    self.streetLabel.textColor = ColorLightGray;
    self.bottomLineView.backgroundColor = ColorLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateWith:(NSString *)name tel:(NSString *)tel tagged:(BOOL)tagged provinces:(NSString *)provinces street:(NSString *)street {
    self.orderUserNameLabel.text = name;
    self.orderUserTelLabel.text = tel;
    self.taggedLabel.hidden = !tagged;
    self.provincesLabel.text = provinces;
    self.streetLabel.text = street;
}

- (void)hidenArrowRView {
    self.arrowRView.hidden = YES;
}

- (CGFloat)getViewHeight {
    return 88.0f;
}


@end
