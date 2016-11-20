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

@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDeductionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDeductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@end

@implementation BN_ShopOrderBillView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.availablePointsLabel.font = Font12;
    self.availablePointsLabel.textColor = ColorBlack;
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@¥%.2f",TEXT(@"可用0积分抵"),0.0];
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

- (IBAction)deductionedPoint:(id)sender {
    self.selectedButton.selected = !self.selectedButton.isSelected;
}

- (void)addDeductionedPointForSelectedWithTask:(void (^)(BOOL deductioned))task {
    [self.selectedButton bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change){
        if (task) {
            task([[change objectForKey:@"new"] boolValue]);
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateWith:(NSString *)availablePoints retailPrice:(NSString *)retailPrice pointDeduction:(NSString *)pointDeduction freight:(NSString *)freight deductioned:(BOOL)deductioned {
    self.availablePointsLabel.text = availablePoints;
    self.retailPriceLabel.text = retailPrice;
    self.pointDeductionLabel.text = pointDeduction;
    self.freightLabel.text = freight;
    self.selectedButton.selected = deductioned;
}

- (CGFloat)getViewHeight {
    return 174.0f;
}


@end
