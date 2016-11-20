//
//  BN_ShopHomeFlashSaleView.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeFlashSaleView.h"
#import "LYFreeTimingPlate.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "PureLayout.h"


@interface BN_ShopHomeFlashSaleView () <LYFreeTimingPlateDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet LYFreeTimingPlate *timingPlate;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopHomeFlashSaleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = Font15;
    self.titleLabel.textColor = ColorBlack;
    
    self.instructionLabel.font = Font10;
    self.instructionLabel.textColor = ColorLightGray;
    
    self.priceLabel.textColor = ColorLightGray;
    self.priceLabel.font = Font15;
    
    self.bottomLineView.backgroundColor = ColorLine;
    
    LYFreeTimingPlate *plate = [LYFreeTimingPlate nib];
    plate.countdownToLastSeconds = 0;
    [plate updateMinusPlate];
    [self addSubview:plate];
    [plate autoSetDimension:ALDimensionHeight toSize:40];
    [plate autoSetDimension:ALDimensionWidth toSize:100];
    [plate autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.priceLabel withOffset:-2];
    [plate autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.priceLabel withOffset:-5];
    plate.delegate = self;
    self.timingPlate = plate;
    
    self.thumbnailImg.q_BorderColor = ColorLine;
    self.thumbnailImg.q_BorderWidth = 1.0f;
}

- (void)dealloc
{
    [self.timingPlate cancelTimer];
    self.timingPlate = nil;
}

- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title instruction:(NSString *)instruction price:(NSAttributedString *)price {
    
    [self.thumbnailImg sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:IMAGE(@"")];
    self.titleLabel.text = title;
    self.instructionLabel.text = instruction;
    self.priceLabel.attributedText = price;
}

- (void)updateWith:(NSDate *)countDownDate title:(NSString *)title countdownToLastSeconds:(NSInteger)countdownToLastSeconds plus:(BOOL)plus {
    self.timingPlate.date = countDownDate;
    self.timingPlate.countdownToLastSeconds = countdownToLastSeconds;
    self.timingPlate.titleStr = title;
    if (plus) {
        [self.timingPlate updatePlusPlate];
    } else {
        [self.timingPlate updateMinusPlate];
    }
    
}

- (CGFloat)getViewHeight {
    return 188.0f;
}

#pragma mark - LYFreeTimingPlateDelegate

- (void)countdownToLastSecondsWillEnd:(LYFreeTimingPlate *)remainderView countdownToLastSeconds:(NSInteger)countdownToLastSeconds {
    NSLog(@"LYFreeTimingPlateDelegate = %ld", (long)countdownToLastSeconds);
    if ([self.delegate respondsToSelector:@selector(countdownToLastSecondsWillEnd:)]) {
        [self.delegate countdownToLastSecondsWillEnd:countdownToLastSeconds];
    }
}

- (void)countdownToLastDidEnd:(LYFreeTimingPlate *)remainderView {
    NSLog(@"LYFreeTimingPlateDelegate 结束啦");
    if ([self.delegate respondsToSelector:@selector(countdownToLastDidEnd:)]) {
        [self.delegate countdownToLastDidEnd];
    }
}

@end


@implementation BN_ShopHomeFlashSaleView (RAC)

- (RACSignal *)rac_countdownToLastSecondsWillEndSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(countdownToLastSecondsWillEnd:) fromProtocol:@protocol(BN_ShopHomeFlashSaleViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_ccountdownToLastDidEndSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(countdownToLastDidEnd) fromProtocol:@protocol(BN_ShopHomeFlashSaleViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
