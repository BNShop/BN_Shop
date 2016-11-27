//
//  BN_ShopGoodDetailNewArribalsCell.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailNewArribalsCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopGoodDetailNewArribalsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation BN_ShopGoodDetailNewArribalsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.q_BorderWidth = 1.0f;
    self.imgView.q_BorderColor = ColorLine;
}

- (void)updateWith:(NSString *)imgUrl {
    [self.imgView sd_setImageWithURL:[imgUrl URL] placeholderImage:nil];
}

@end
