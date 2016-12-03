//
//  BN_ShopOrderBillView.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderBillView.h"
#import "NSObject+BKBlockObservation.h"

@interface BN_ShopOrderBillView ()
@property (weak, nonatomic) IBOutlet UILabel *retailPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDeductionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDeductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopOrderBillView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomLineView.backgroundColor = ColorLine;
    self.retailPriceTitleLabel.font = Font12;
    self.retailPriceTitleLabel.textColor = ColorGray;
    self.retailPriceTitleLabel.text = TEXT(@"商品总额");
    self.pointDeductionTitleLabel.font = Font12;
    self.pointDeductionTitleLabel.textColor = ColorGray;
    self.pointDeductionTitleLabel.text = TEXT(@"积分抵扣");
    self.freightTitleLabel.font = Font12;
    self.freightTitleLabel.textColor = ColorGray;
    self.freightTitleLabel.text = TEXT(@"运费");
    
    self.retailPriceLabel.font = Font12;
    self.retailPriceLabel.textColor = ColorRed;
    self.retailPriceLabel.text = @"¥0.00";
    self.pointDeductionLabel.font = Font12;
    self.pointDeductionLabel.textColor = ColorRed;
    self.pointDeductionLabel.text = @"-¥0.00";
    self.freightLabel.font = Font12;
    self.freightLabel.textColor = ColorRed;
    self.freightLabel.text = @"+¥0.00";
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateWith:(NSString *)retailPrice pointDeduction:(NSString *)pointDeduction freight:(NSString *)freight {
    self.retailPriceLabel.text = [NSString stringWithFormat:@"¥%@", retailPrice];
    self.pointDeductionLabel.text = [NSString stringWithFormat:@"-¥%@", pointDeduction];;
    self.freightLabel.text = [NSString stringWithFormat:@"+¥%@", freight];
}

- (CGFloat)getViewHeight {
    return 134.0f;
}


@end
