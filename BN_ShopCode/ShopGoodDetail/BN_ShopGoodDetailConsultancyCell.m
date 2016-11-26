//
//  BN_ShopGoodDetailConsultancyCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailConsultancyCell.h"

@interface BN_ShopGoodDetailConsultancyCell ()
@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopGoodDetailConsultancyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.qLabel.font = Font12;
    self.qLabel.textColor = ColorGray;
    self.aLabel.font = Font12;
    self.aLabel.textColor = ColorLightGray;
    self.bottomLineView.backgroundColor = ColorLine;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)question answer:(NSString *)answer {
    self.qLabel.text = question;
    self.aLabel.text = answer;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.qLabel sizeToFit];
        [self.aLabel sizeToFit];
    });
}

@end
