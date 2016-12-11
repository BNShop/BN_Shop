//
//  BN_ShopGoodDetailSellersView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailSellersView.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIView+BlocksKit.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailSellersView ()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;

@end

@implementation BN_ShopGoodDetailSellersView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLineView.backgroundColor = ColorLine;
    self.bottomLineView.backgroundColor = ColorLine;
    self.iconImgView.q_BorderColor = ColorLine;
    self.iconImgView.q_BorderWidth = 1.0f;
    self.sellerNameLabel.font = Font12;
    self.sellerNameLabel.textColor = ColorGray;
    
}

- (void)updateWith:(NSString *)sellerName iconUrl:(NSString *)iconUrl {
    self.sellerNameLabel.text = sellerName;
    [self.iconImgView sd_setImageWithURL:[iconUrl URL] placeholderImage:nil];
}

- (CGFloat)getViewHeight {
    return 77.0f;
}

@end
