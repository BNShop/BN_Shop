//
//  BN_ShopSpecialSubjectTipCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectTipCell.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialSubjectTipCell ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation BN_ShopSpecialSubjectTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tipLabel.font = Font10;
    self.tipLabel.textColor = ColorBtnYellow;
    self.tipLabel.q_BorderColor = ColorBtnYellow;
    self.tipLabel.q_BorderWidth = 1.0f;
}

- (void)updateWith:(NSString *)tip {
    self.tipLabel.text = tip;
}

@end
