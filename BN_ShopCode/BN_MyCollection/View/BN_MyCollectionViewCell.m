//
//  BN_MyCollectionViewCell.m
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_MyCollectionViewCell.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"
#import "BN_ShopHeader.h"

@interface BN_MyCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak,nonatomic) IBOutlet UILabel *coverLabel;// 提示膜层

@end

@implementation BN_MyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.priceLabel.textColor = ColorBlack;
    self.priceLabel.font = Font15;
    self.thumbnailImageView.q_BorderColor = ColorLine;
    self.thumbnailImageView.q_BorderWidth = 1.0f;
    self.oldPrice.textColor = ColorGray;
    self.oldPrice.font = Font8;
    self.commentNum.textColor = ColorGray;
    self.commentNum.font = Font8;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverLabel.hidden = YES;
    self.coverLabel.font = Font16;
    self.coverLabel.backgroundColor = RGBAHEX(0x626262, 0.7);
    self.coverLabel.textColor = [UIColor whiteColor];
    self.coverLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.coverLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateWith:(BOOL)isSelect model:(BN_MycollectionModel *)model
{
    self.radioButton.selected = !isSelect;
    self.radioButton.hidden = !model.isEdit;
    [self.thumbnailImageView sd_setImageWithURL:[model.pic_url URL] placeholderImage:nil];
    self.titleLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.front_price];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", model.real_price]
                                  attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:8.0],NSForegroundColorAttributeName:[UIColor lightGrayColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
    
    self.oldPrice.attributedText = attrStr;
    self.commentNum.text = [NSString stringWithFormat:@"%d条评论",model.total_comment];
    if (model.avail_buying_num == 0) {
        self.coverLabel.hidden = NO;
        self.coverLabel.text = @"无货";
    }
    if (model.cur_state == 0) {
        self.coverLabel.hidden = NO;
        self.coverLabel.text = @"商品已下架";
    }
    
//    if (model.buying_state == 2) {
//        self.coverLabel.hidden = NO;
//        self.coverLabel.text = @"抢购结束";
//    }
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
