//
//  BN_ShopScreeningResuablePriceCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningResuablePriceCell.h"
#import "UITextField+BlocksKit.h"
#import "BN_ShopHeader.h"

@interface BN_ShopScreeningResuablePriceCell ()

@property (weak, nonatomic) IBOutlet UITextField *minPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *maxPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *midLineView;


@end

@implementation BN_ShopScreeningResuablePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.minPriceLabel.textColor = ColorGray;
    self.maxPriceLabel.textColor = ColorGray;
    self.minPriceLabel.font = Font10;
    self.maxPriceLabel.font = Font10;
    self.minPriceLabel.q_BorderColor = ColorLine;
    self.maxPriceLabel.q_BorderColor = ColorLine;
    self.minPriceLabel.q_BorderWidth = 1.0f;
    self.maxPriceLabel.q_BorderWidth = 1.0f;
    self.minPriceLabel.tintColor = ColorLightGray;
    self.maxPriceLabel.tintColor = ColorLightGray;
    self.midLineView.backgroundColor = ColorLightGray;
}

- (void)setPriceChangedBlock:(void (^)(NSString *text, NSInteger indexPath)) block {
    [self.minPriceLabel setBk_shouldClearBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 0);
        }
        return YES;
    }];
    @weakify(self);
    [self.minPriceLabel setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 0);
        }
        @strongify(self);
        [self.maxPriceLabel becomeFirstResponder];
        return YES;
    }];
    [self.minPriceLabel setBk_shouldEndEditingBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 0);
        }
        return YES;
    }];
    [self.maxPriceLabel setBk_shouldClearBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 1);
        }
        return YES;
    }];
    [self.maxPriceLabel setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 1);
        }
        @strongify(self);
        [self.maxPriceLabel resignFirstResponder];
        return YES;
    }];
    [self.maxPriceLabel setBk_shouldEndEditingBlock:^BOOL(UITextField *textField) {
        if (block) {
            block(textField.text, 1);
        }
        return YES;
    }];
}

- (void)updateWith:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    self.minPriceLabel.text = minPrice;
    self.maxPriceLabel.text = maxPrice;
}


@end
