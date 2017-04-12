//
//  BN_ShopOrderProcessingView.m
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderProcessingView.h"
#import "BGButton.h"
#import "UIControl+BlocksKit.h"
#import "BN_ShopHeader.h"

@interface BN_ShopOrderProcessingView ()

@property (weak, nonatomic) IBOutlet BGButton *leftButton;
@property (weak, nonatomic) IBOutlet BGButton *rightButton;


@end

@implementation BN_ShopOrderProcessingView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.leftButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:Font12];
    self.leftButton.normalColor = ColorLightGray;
    [self.rightButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:Font12];
    self.rightButton.normalColor = ColorBtnYellow;
}


- (CGFloat)getViewHeight {
    return 68.0f;
}

- (void)addLeftEventHandler:(void (^)(id sender))handler {
    [self.leftButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    
    if (handler) {
        [self.leftButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
        self.leftButton.hidden = NO;
    } else {
        self.leftButton.hidden = YES;
    }
}

- (void)addRightEventHandler:(void (^)(id sender))handler {
    [self.rightButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    if (handler) {
        [self.rightButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.hidden = NO;
    } else {
        self.rightButton.hidden = YES;
    }
}

- (void)updateWith:(NSString *)left rightTitle:(NSString *)right {
    [self.leftButton setTitle:left forState:UIControlStateNormal];
    [self.rightButton setTitle:right forState:UIControlStateNormal];
}
@end
