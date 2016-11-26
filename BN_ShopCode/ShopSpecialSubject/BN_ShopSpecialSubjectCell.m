//
//  BN_ShopSpecialSubjectCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectCell.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopSpecialSubjectCell ()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *fenceLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopToImgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopToImgBottom;
@end

@implementation BN_ShopSpecialSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLineView.backgroundColor = ColorLine;
    self.fenceLineView.backgroundColor = ColorLine;
    self.numLabel.q_BorderWidth = 1.0f;
    self.numLabel.q_BorderColor = ColorRed;
    self.numLabel.textColor = ColorRed;
    self.numLabel.font = Font16;
    
    self.titleLabel.textColor = ColorRed;
    self.titleLabel.font = Font16;
    
    self.subTitleLabel.textColor = ColorLightGray;
    self.subTitleLabel.font = Font12;
    
    self.contentLabel.textColor = ColorLightGray;
    self.contentLabel.font = Font12;
    
    self.followLabel.textColor = ColorLightGray;
    self.followLabel.font = Font10;
    
    self.priceLabel.textColor = ColorRed;
    self.priceLabel.font = Font16;
    
    self.button.q_BorderColor = ColorRed;
    self.button.q_BorderWidth = 1.0f;
    [self.button setTitleColor:ColorRed forState:UIControlStateNormal];
    self.button.titleLabel.font = Font10;
    [self.button setTitle:TEXT(@"立即购买") forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickedAction:(void (^)(id sender))handler {
    [self.button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateWith:(NSString *)num title:(NSString *)title subTitle:(NSString *)subTitle content:(NSAttributedString *)conten follow:(NSString *)follow price:(NSAttributedString *)price {
    self.numLabel.text = num;
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.contentLabel.attributedText = conten;
    
    self.followLabel.text = follow;
    self.priceLabel.attributedText = price;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.titleLabel sizeToFit];
        self.titleWidth.constant = [self.titleLabel sizeThatFits:CGSizeZero].width;
        [self.contentLabel sizeToFit];
        [self.numLabel sizeToFit];
        self.numWidth.constant = MAX(WIDTH(self.numLabel)+10, 20);
        
    });
}


- (void)updateWith:(NSString *)imgUrl subImgUrl:(NSString *)subImgUrl completed:(void(^)(id cell))block {
    self.imgView.image = nil;
    if ([imgUrl isURLString]) {
        self.viewTopToImgBottom.constant = 10;
        self.imgHeight.constant = 20;
        @weakify(self);
        [self.imgView sd_setImageWithURL:[imgUrl URL] placeholderImage:IMAGE(@"") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (image.size.width > 0) {
                self.imgHeight.constant = image.size.height * WIDTH(self) / image.size.width;
            } else {
                self.imgHeight.constant = 1;
                self.viewTopToImgBottom.constant = -8;
            }
            if (block) {
                block(self);
            }
        }];
    } else {
        self.imgHeight.constant = 0;
        self.viewTopToImgBottom.constant = -8;
    }
    self.subImgView.image = nil;
    if ([subImgUrl isURLString]) {
         self.contentTopToImgBottom.constant = 10;
        self.subImgHeight.constant = 20;
        @weakify(self);
        [self.subImgView sd_setImageWithURL:[subImgUrl URL] placeholderImage:IMAGE(@"") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (image.size.width > 0) {
                self.subImgHeight.constant = image.size.height * WIDTH(self) / image.size.width;
                
            } else {
                self.subImgHeight.constant = 1;
            self.contentTopToImgBottom.constant = -8;
            }
            if (block) {
                block(self);
            }
        }];
    } else {
        self.subImgHeight.constant = 1;
        self.contentTopToImgBottom.constant = -8;
        
    }
}


@end
