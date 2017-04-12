//
//  BN_MSouvenirTableViewCell.m
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_MSouvenirTableViewCell.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"

@implementation BN_MSouvenirTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.font = Font15;
    self.bottomLine.backgroundColor = ColorBlack;
    
    self.ADImageView.userInteractionEnabled = YES;
    self.ADImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.titleLabel.userInteractionEnabled = YES;
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 0, 40, 40)];
    [self.collectBtn setImage:[UIImage imageNamed:@"Shop_GoodDetail_FollowD"] forState:UIControlStateSelected];
    [self.collectBtn setImage:[UIImage imageNamed:@"Shop_GoodDetail_UnFollow"] forState:UIControlStateNormal];
    // Shop_GoodDetail_UnFollow
    [self.collectBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.collectBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateWith:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl model:(BN_MySouvenirModel *)model
{
    self.titleLabel.text = title;
    self.collectBtn.selected = model.isCollected;
    [self.ADImageView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:nil];
}

- (void)collectionBtnClick {
    self.collectBtn.selected = !self.collectBtn.selected;
    if (self.collect) {
        self.collect();
    }
}

@end
