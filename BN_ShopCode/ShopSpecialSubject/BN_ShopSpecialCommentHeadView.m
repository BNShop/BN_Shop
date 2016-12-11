//
//  BN_ShopSpecialCommentHeadView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialCommentHeadView.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialCommentHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgs;
@property (weak, nonatomic) IBOutlet UIView *topLineView;


@end

@implementation BN_ShopSpecialCommentHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBtnYellow;
    self.topLineView.backgroundColor = ColorBackground;
    
}

- (void)clickedFollowAction:(void (^)(id sender))handler {
    [self.addButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateWith:(NSString *)titile follow:(BOOL)follow {
    self.titleLabel.text = titile;
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
}

- (CGFloat)getViewHeight {
    return 94.0f;
}

@end
