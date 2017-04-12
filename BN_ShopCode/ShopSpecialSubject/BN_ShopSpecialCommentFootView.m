//
//  BN_ShopSpecialCommentFootView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialCommentFootView.h"
#import "UIControl+BlocksKit.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialCommentFootView ()
@property (weak, nonatomic) IBOutlet UIButton *comentButton;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@end

@implementation BN_ShopSpecialCommentFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.comentButton setTitleColor:ColorBlack forState:UIControlStateNormal];
    self.comentButton.titleLabel.font = Font12;
    self.comentButton.q_BorderWidth = 1.0f;
    self.comentButton.q_BorderColor = ColorLightGray;
    
    self.topLineView.backgroundColor = ColorLine;
}

- (void)clickedCommentAction:(void (^)(id sender))handler {
    [self.comentButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
}

- (CGFloat)getViewHeight {
    return 60.0f;
}

@end
