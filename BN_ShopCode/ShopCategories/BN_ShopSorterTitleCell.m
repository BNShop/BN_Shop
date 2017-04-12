//
//  BN_ShopSorterTitleCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSorterTitleCell.h"
#import "UITableViewCell+Selection.h"
#import "NSObject+BKBlockObservation.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSorterTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

@implementation BN_ShopSorterTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorGray;
    self.leftLineView.backgroundColor = ColorLine;
    self.bottomLineView.backgroundColor = ColorLine;
    [self setSelectionColor:ColorBackground];
    
    @weakify(self);
    [self bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        @strongify(self);
        self.leftLineView.hidden = [[change objectForKey:@"selected"] boolValue];
        self.titleLabel.textColor = self.leftLineView.hidden ? ColorBtnYellow : ColorGray;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)title selected:(BOOL)selected {
    self.titleLabel.text = title;
    self.selected = selected;
}

@end
