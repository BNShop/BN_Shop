//
//  BN_ShopSearchCollectionReusableView.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSearchCollectionReusableView.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIControl+BlocksKit.h"

@interface BN_ShopSearchCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;



@end

@implementation BN_ShopSearchCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font12;
    [self.processButton setTitle:TEXT(@"删除") forState:UIControlStateNormal];
    [self.processButton setTitleColor:ColorGray forState:UIControlStateNormal];
    self.processButton.titleLabel.font = Font12;
    self.processButton.hidden = YES;
    [self.iconImage setContentMode:UIViewContentModeCenter];
    
}

- (void)addOkEventHandler:(void (^)(id sender))handler {
    if (handler) {
        [self.processButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
        self.processButton.hidden = NO;
    } else {
         [self.processButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        self.processButton.hidden = YES;
    }
    
}

- (void)updateWith:(NSString *)iconUrl title:(NSString *)title {
    if (iconUrl.isURLString) {
        [self.iconImage sd_setImageWithURL:[iconUrl URL] placeholderImage:IMAGE(@"")];
    } else {
        [self.iconImage setImage:IMAGE(iconUrl)];
    }
    self.titleLabel.text = title;
}

- (CGFloat)getViewHeight {
    return 40.0f;
}



@end
