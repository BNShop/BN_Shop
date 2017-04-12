//
//  BN_ShopSpecialCommentCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialCommentCell.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialCommentCell ()

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgs;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;


@end

@implementation BN_ShopSpecialCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLineView.backgroundColor = ColorLine;;
    
    self.nameLabel.textColor = ColorGray;
    self.nameLabel.font = Font12;
    
    self.contentLabel.textColor = ColorGray;
    self.contentLabel.font = Font12;
    
    self.dateLabel.textColor = ColorGray;
    self.dateLabel.font = Font10;
    
    self.followNumLabel.textColor = ColorGray;
    self.followNumLabel.font = Font10;
    
    self.comentNumLabel.textColor = ColorGray;
    self.comentNumLabel.font = Font10;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickedFollowAction:(void (^)(id sender))handler {
    @weakify(self);
    [self.followButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self.followButton setSelected:!self.followButton.isSelected];
        handler(sender);
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickedComentAction:(void (^)(id sender))handler {
    [self.commentButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateWith:(NSString *)iconUrl name:(NSString *)name content:(NSString *)content date:(NSString *)date{
    [self.iconImgView sd_setImageWithURL:[iconUrl URL] placeholderImage:nil];
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    self.dateLabel.text = date;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentLabel sizeToFit];
    });
}

- (void)updateWith:(NSString *)followNum comentNum:(NSString *)comentNum follow:(BOOL)follow {
    self.followNumLabel.text = followNum;
    self.comentNumLabel.text = comentNum;
    [self.followButton setSelected:follow];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.followNumLabel sizeToFit];
        [self.comentNumLabel sizeToFit];
    });
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
        [img sd_setImageWithURL:[[urls objectAtIndex:index] URL] placeholderImage:IMAGE(@"Shop_Home_Type0")];
        
        img.hidden = NO;
    }
    if (imgUrls.count > 0) {
        self.imgHeight.constant = 65.0f;
    } else {
        self.imgHeight.constant = 0.0f;
    }
}

@end
