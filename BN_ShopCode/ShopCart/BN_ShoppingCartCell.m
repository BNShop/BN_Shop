//
//  BN_ShoppingCartCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShoppingCartCell.h"
#import "PKYStepper.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"

@interface BN_ShoppingCartCell ()
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PKYStepper *stepper;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BN_ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.bottomLineView.backgroundColor = ColorLine;
    self.priceLabel.textColor = ColorRed;
    self.priceLabel.font = Font12;
    self.thumbnailImageView.q_BorderColor = ColorLine;
    self.thumbnailImageView.q_BorderWidth = 1.0f;
    self.thumbnailImageView.backgroundColor = [UIColor yellowColor];
    
    @weakify(self)
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        @strongify(self);
        [self valueChanged:count];
    };
    [self.stepper setLabelTextColor:[UIColor blackColor]];
    [self.stepper setLabelFont:Font10];
    [self.stepper setButtonWidth:21.0f];
    [self.stepper setButtonTextColor:ColorLightGray forState:UIControlStateNormal];
    [self.stepper setButtonFont:Font14];
    [self.stepper setBorderColor:ColorLightGray];
    [self.stepper setup];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWith:(BOOL)isSelect thumbnailUrl:(NSString *)thumbnailUrl title:(NSString *)title num:(NSInteger)num price:(NSString *)price {
    self.radioButton.selected = isSelect;
    [self.thumbnailImageView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:IMAGE(@"")];
    self.titleLabel.text = title;
    self.stepper.value = num;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", price];
}

- (IBAction)selectAction:(id)sender {
    self.radioButton.selected = !self.radioButton.isSelected;
    if ([_delegate respondsToSelector:@selector(selectActionWith:selected:)]) {
        [_delegate selectActionWith:self selected:self.radioButton.selected];
    }
}

#pragma mark - stepper's value changed
- (void)valueChanged:(float)count {
    if ([_delegate respondsToSelector:@selector(valueChangedWith:count:)]) {
        [_delegate valueChangedWith:self count:count];
    }
}

@end
