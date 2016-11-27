//
//  BN_ShopScreeningReusableView.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningReusableView.h"
#import "V_LineLayer.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface BN_ShopScreeningReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) V_LineLayer *vLayer;
@property (weak, nonatomic) IBOutlet UIView *vView;

@end

@implementation BN_ShopScreeningReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImgView.contentMode =  UIViewContentModeCenter;
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font12;
    
    self.vLayer = [[V_LineLayer alloc] init];
    [self.vLayer setStrokeColorWith:ColorGray];
    [self.vLayer setLineTHWidth:1.0f];
    [self.vLayer setLineWidth:0 vWidth:WIDTH(self.vView) vHeight:HEIGHT(self.vView)];
    [self.vLayer setVDirection:V_LINE_DIRECTION_DOWN];
    [self.vLayer v_LineWith:CGRectMake(0, 0, WIDTH(self.vView), HEIGHT(self.vView))];
    [[self.vView layer] addSublayer:self.vLayer];
    
}

- (void)updateWith:(NSString *)iconUrl title:(NSString *)title {
    if (iconUrl.isURLString) {
        [self.iconImgView sd_setImageWithURL:[iconUrl URL] placeholderImage:nil];
    } else {
        [self.iconImgView setImage:IMAGE(iconUrl)];
    }
    self.titleLabel.text = title;
}

- (CGFloat)getViewHeight {
    return 40.0f;
}

@end
