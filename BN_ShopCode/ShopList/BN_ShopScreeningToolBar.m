//
//  BN_ShopScreeningToolBar.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningToolBar.h"
#import "BGButton.h"
#import "UIControl+BlocksKit.h"
#import "BN_ShopHeader.h"

@interface BN_ShopScreeningToolBar ()
@property (weak, nonatomic) IBOutlet BGButton *cancelButton;
@property (weak, nonatomic) IBOutlet BGButton *okButton;

@end

@implementation BN_ShopScreeningToolBar
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cancelButton setNormalColor:ColorWhite];
    [self.cancelButton setTitle:TEXT(@"取消") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:ColorBtnYellow forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:Font12];
    
    [self.okButton setNormalColor:ColorBtnYellow];
    [self.okButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.okButton setTitle:TEXT(@"确定") forState:UIControlStateNormal];
    [self.okButton.titleLabel setFont:Font12];
}

- (void)addOkEventHandler:(void (^)(id sender))handler {
    [self.okButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCancleEventHandler:(void (^)(id sender))handler {
    [self.cancelButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)getViewHeight {
    return 52.0f;
}

@end
