//
//  BN_ShopGoodDetailNewestOrdersView.m
//  BN_Shop
//
//  Created by Liya on 2017/1/7.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailNewestOrdersView.h"
#import "BN_ShopHeader.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopGoodDetailNewestOrdersView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BN_ShopGoodDetailNewestOrdersView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.q_CornerRadius = 14.5;
    self.titleLabel.textColor = ColorLine;
    self.titleLabel.font = Font12;
}


- (void)updateWith:(NSString *)iconUrl title:(NSString *)title {
    [self.imageView sd_setImageWithURL:[iconUrl URL]];
    [self.titleLabel setText:title];
}

- (CGFloat)getViewWidth {
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 21.0)];
    tempLabel.font = self.titleLabel.font;
    tempLabel.text = self.titleLabel.text;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return MIN(size.width + 29 + 4*3, DeviceWidth-23-5);
}
@end
