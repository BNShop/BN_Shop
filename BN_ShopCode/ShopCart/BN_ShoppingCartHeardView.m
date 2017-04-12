//
//  BN_ShoppingCartHeardView.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShoppingCartHeardView.h"
#import "BN_ShopHeader.h"

@interface BN_ShoppingCartHeardView ()
@property (weak, nonatomic) IBOutlet UILabel *warningTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundUpLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIButton *e_resizeButton;

@property (copy, nonatomic) void(^roundUpBlock)(id obj);
@end

@implementation BN_ShoppingCartHeardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.warningTitleLabel.font = Font10;
    self.warningTitleLabel.textColor = ColorLightGray;
    self.roundUpLabel.font = Font10;
    self.roundUpLabel.textColor = ColorLightGray;
    self.bottomLineView.backgroundColor = ColorLine;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)roundUp:(id)sender {
    if (self.roundUpBlock) {
        self.roundUpBlock(nil);
    }
}

#pragma mark - 
- (CGFloat)getViewHeight {
    return 36.0f;
}

- (void)updateWith:(NSString *)warningTitle roundUpTitle:(NSString *)roundUpTitle roundUpBlock:(void(^)(id obj)) block{
    self.warningTitleLabel.text = warningTitle;
    self.roundUpLabel.text = roundUpTitle;
    self.e_resizeButton.hidden = !roundUpTitle;
    self.roundUpBlock = block;
}
@end
