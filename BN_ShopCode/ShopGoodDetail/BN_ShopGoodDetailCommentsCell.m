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

@interface BN_ShopGoodDetailCommentsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgs;


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
    [self.iconImgView sd_setImageWithURL:[icon URL] placeholderImage:IMAGE(@"")];
    self.iconImgView.backgroundColor = [UIColor redColor];
}

- (void)updateWith:(NSArray *)imgUrls {
    NSInteger count = MIN(imgUrls.count, self.imgs.count);
    for (UIImageView *img in self.imgs) {
        img.hidden = YES;
        img.image = nil;
    }
    NSArray *urls = imgUrls.copy;
    for (NSInteger index = 0; index < count; index++) {
        UIImageView *img = [self.imgs objectAtIndex:index];
//        [img sd_setImageWithURL:[[urls objectAtIndex:index] URL] placeholderImage:IMAGE(@"")];
        [img sd_setImageWithURL:[[urls objectAtIndex:index] URL] placeholderImage:IMAGE(@"Shop_Home_Type0")];
        img.hidden = NO;
    }
}


@end
