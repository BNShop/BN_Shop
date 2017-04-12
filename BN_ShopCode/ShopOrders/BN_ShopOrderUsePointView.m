//
//  BN_ShopOrderUsePointView.m
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderUsePointView.h"
#import "NSObject+BKBlockObservation.h"
#import "BN_ShopHeader.h"

@interface BN_ShopOrderUsePointView ()

@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopOrderUsePointView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.availablePointsLabel.font = Font12;
    self.availablePointsLabel.textColor = ColorBlack;
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@¥%.2f",TEXT(@"可用0积分抵"),0.0];
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

- (void)updateWith:(NSString *)availablePoints deductioned:(BOOL)deductioned {
    self.availablePointsLabel.text = availablePoints;
    self.selectedButton.selected = deductioned;
}

- (CGFloat)getViewHeight {
    return 40.0f;
}


@end
