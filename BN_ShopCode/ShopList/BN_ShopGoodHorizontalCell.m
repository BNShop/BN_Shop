//
//  BN_ShopGoodHorizontalCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodHorizontalCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BGButton.h"
#import "UIControl+BlocksKit.h"
#import "LYFreeTimingPlate.h"
#import "PureLayout.h"

@interface BN_ShopGoodHorizontalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet BGButton *manageButton;

@property (strong, nonatomic) LYFreeTimingPlate *timingPlate;

@end

@implementation BN_ShopGoodHorizontalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.thumbnailImgView.backgroundColor = ColorLine;
    self.titleLabel.textColor = ColorGray;
    self.titleLabel.font = Font12;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    
    self.realLabel.textColor = ColorLightGray;
    self.realLabel.font = Font8;
    self.realLabel.text = nil;
    
    self.additionalLabel.textColor = ColorLightGray;
    self.additionalLabel.font = Font10;
    
    self.frontLabel.textColor = ColorBlack;
    self.frontLabel.font = Font12;
    
    self.bottomLineView.backgroundColor = ColorLine;
    
    self.manageButton.hidden = YES;
    self.manageButton.titleLabel.textColor = ColorWhite;
    self.manageButton.titleLabel.font = Font12;
    [self.manageButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.manageButton setEnlargeInset:UIEdgeInsetsMake(10, 10, 10, 10)];
}


- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title front:(NSAttributedString *)front real:(NSString *)real additional:(NSString *)additional {
    [self.thumbnailImgView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:nil];
    self.titleLabel.text = title;
    self.frontLabel.text = real;
    self.realLabel.attributedText = front;
    self.additionalLabel.text = additional;
}

- (void)buildTimePlate {
    if (!self.timingPlate) {
        LYFreeTimingPlate *plate = [LYFreeTimingPlate nib];
        plate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:plate];
        [plate autoSetDimension:ALDimensionHeight toSize:14];
        [plate autoSetDimension:ALDimensionWidth toSize:61];
        [plate autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.thumbnailImgView withOffset:120];
        [plate autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.additionalLabel withOffset:8];
        self.timingPlate = plate;
    }
    
}

- (void)updateAdditionalForward:(NSDate *)date state:(int)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.additionalLabel.textColor = ColorBtnYellow;
        self.additionalLabel.font = Font12;
        self.manageButton.normalColor = ColorBtnYellow;
        if (state == -1) {
            [self.manageButton setTitle:TEXT(@"取消提醒") forState:UIControlStateNormal];
        } else {
            [self.manageButton setTitle:TEXT(@"提醒我") forState:UIControlStateNormal];
        }
        [self.manageButton setNeedsDisplay];
        self.additionalLabel.text = TEXT(@"距离开始时间");
        [self.timingPlate updateMinusWhioutBorderPlate:ColorBtnYellow];
        self.timingPlate.date = date;
    });
    
}

- (void)updateAdditionalFrenzied:(NSDate *)date {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.additionalLabel.textColor = ColorRed;
        self.additionalLabel.font = Font12;
        self.manageButton.normalColor = ColorRed;
        [self.manageButton setNeedsDisplay];
        [self.manageButton setTitle:TEXT(@"立即抢购") forState:UIControlStateNormal];
        self.additionalLabel.text = TEXT(@"距离结束时间");
        [self.timingPlate updateMinusWhioutBorderPlate:ColorRed];
        self.timingPlate.date = date;
    });
}

- (void)addManageButtonEvent:(void (^)(id sender))handler {
    self.manageButton.hidden = NO;
    [self.manageButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [self.manageButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelTimer {
    [self.timingPlate cancelTimer];
}
@end
