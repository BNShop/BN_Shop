//
//  BN_ShopGoodDetailCommentsCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailCommentsCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailCommentsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightconstraints;


@end

@implementation BN_ShopGoodDetailCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = ColorLightGray;
    self.nameLabel.font = Font10;
    [self.nameLabel sizeToFit];
    
    self.dateLabel.textColor = ColorLightGray;
    self.dateLabel.font = Font8;
    
    self.contentLabel.textColor = ColorBlack;
    self.contentLabel.font = Font12;
    self.contentLabel.numberOfLines = 0;
//    [self.contentLabel sizeToFit];
    
    self.goodLabel.textColor = ColorLightGray;
    self.goodLabel.font = Font8;
    
    for (UIImageView *img in self.imgs) {
        img.q_BorderColor = ColorLine;
        img.q_BorderWidth = 1.0f;
        img.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)name dateStr:(NSString *)dateStr content:(NSString *)conten goodStr:(NSString *)goodStr icon:(NSString *)icon {
    NSLog(@"%@", conten);
    self.nameLabel.text = name;
    self.dateLabel.text = dateStr;
    self.contentLabel.text = conten;
    self.goodLabel.text = goodStr;
    [self.iconImgView sd_setImageWithURL:[icon URL] placeholderImage:nil];
    self.iconImgView.backgroundColor = [UIColor redColor];
}

- (void)updateWith:(NSArray *)imgUrls {
    NSInteger count = MIN(imgUrls.count, self.imgs.count);
    for (UIImageView *img in self.imgs) {
        img.hidden = YES;
        img.image = nil;
    }
    if (imgUrls.count == 0) {
        self.imgHeightconstraints.constant = 1.0;
    } else {
        self.imgHeightconstraints.constant = 75.0;
    }
    NSArray *urls = imgUrls.copy;
    for (NSInteger index = 0; index < count; index++) {
        UIImageView *img = [self.imgs objectAtIndex:index];
        [img sd_setImageWithURL:[[urls objectAtIndex:index] URL] placeholderImage:nil];
        img.hidden = NO;
    }
}


@end
