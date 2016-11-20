//
//  BN_ShopOrdersItemCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersItemCell.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"

@interface BN_ShopOrdersItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopOrdersItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumbnailImgView.q_BorderWidth = 1.0f;
    self.thumbnailImgView.q_BorderColor = ColorLine;
    self.unitPriceLabel.textColor = ColorRed;
    self.unitPriceLabel.font = Font12;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font12;
    [self.titleLabel sizeToFit];
    self.specificationLabel.textColor = ColorLightGray;
    self.specificationLabel.font = Font10;
    self.numLabel.textColor = ColorGray;
    self.numLabel.font = Font12;
    self.bottomLineView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title num:(NSInteger)num price:(NSString *)price specification:(NSString *)specification {
    [self.thumbnailImgView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:IMAGE(@"")];
    self.titleLabel.text = title;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"¥%@", price];
    self.specificationLabel.text = specification;
    self.numLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
}
@end
