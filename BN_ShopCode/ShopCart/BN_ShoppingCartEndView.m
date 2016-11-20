//
//  BN_ShoppingCartEndView.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShoppingCartEndView.h"
#import "BGButton.h"
#import "NSObject+BKBlockObservation.h"
#import "NSString+Attributed.h"

@interface BN_ShoppingCartEndView ()
@property (weak, nonatomic) IBOutlet UIButton *RadioButton;
@property (weak, nonatomic) IBOutlet UILabel *CheckAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *TotalAmountLabel;
@property (weak, nonatomic) IBOutlet BGButton *DeleteButton;
@property (weak, nonatomic) IBOutlet BGButton *SettlementButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

@implementation BN_ShoppingCartEndView

#pragma mark - lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.CheckAllLabel.font = Font12;
    self.CheckAllLabel.textColor = ColorGray;
    self.TotalAmountLabel.font = Font12;
    self.TotalAmountLabel.textColor = ColorRed;
    self.DeleteButton.normalColor = ColorBtnYellow;
    [self.DeleteButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.DeleteButton.titleLabel.font = Font15;
    self.SettlementButton.normalColor = ColorBtnYellow;
    [self.SettlementButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.SettlementButton.titleLabel.font = Font15;
    NSString *price = [NSString stringWithFormat:@"%@(0.00)", TEXT(@"结算")];
    [self.SettlementButton setAttributedTitle:[price setFont:Font15 restFont:(UIFont *)Font10 range:[price rangeOfString:TEXT(@"结算")]] forState:UIControlStateNormal];
    self.bottomLineView.backgroundColor = ColorLine;

    
    
    [self setEdit:NO];

    @weakify(self);
    [self.RadioButton bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        @strongify(self);
        self.CheckAllLabel.text = [[change objectForKey:@"new"] boolValue] ? TEXT(@"取消全选") : TEXT(@"全选");
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setEdit:(BOOL)edit {
    _edit = edit;
    self.DeleteButton.hidden = !_edit;
    self.SettlementButton.hidden = _edit;
    self.TotalAmountLabel.hidden = _edit;
}


#pragma mark - operations for tagger

- (IBAction)selectAll:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectAll:)]) {
        [_delegate selectAll:self.RadioButton.isSelected];
    }
    self.RadioButton.selected = !self.RadioButton.selected;
    
}

- (IBAction)deleteTagger:(id)sender {
    if ([_delegate respondsToSelector:@selector(deleteTagger)]) {
        [_delegate deleteTagger];
    }
    
    self.RadioButton.selected = NO;
}

- (IBAction)settlementTagger:(id)sender {
    if ([_delegate respondsToSelector:@selector(settlementTagger)]) {
        [_delegate settlementTagger];
    }
}

#pragma mark - 
- (CGFloat)getViewHeight {
    return 52.0f;
}

- (void)updateWith:(BOOL)isCheckAll {
    self.RadioButton.selected = isCheckAll;
}

- (void)updateWith:(NSString *)totalAmount settlementTitle:(NSAttributedString *)settlementTitle {
    self.TotalAmountLabel.text = totalAmount;
    [self.SettlementButton setAttributedTitle:settlementTitle forState:UIControlStateNormal];
}
@end
