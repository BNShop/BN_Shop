//
//  BN_ShopGoodDetaiForwardStateView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetaiForwardStateView.h"
#import "LYFreeTimingPlate.h"
#import "PureLayout.h"

@interface BN_ShopGoodDetaiForwardStateView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pirceBackWidth;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (strong, nonatomic) LYFreeTimingPlate *timingPlate;
@property (weak, nonatomic) IBOutlet UIView *priceBackView;
@property (weak, nonatomic) IBOutlet UIView *stateBackView;
@property (weak, nonatomic) IBOutlet UIView *priceDriftView;

@end

@implementation BN_ShopGoodDetaiForwardStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceBackView.backgroundColor = ColorBtnYellow;
    self.stateBackView.backgroundColor = ColorBackground;
    self.realPriceLabel.textColor = ColorWhite;
    self.realPriceLabel.font = [UIFont systemFontOfSize:20.0f];//Font16;
    [self.realPriceLabel sizeToFit];
    self.frontPriceLabel.textColor = ColorWhite;
    self.frontPriceLabel.font = Font8;
    self.followLabel.textColor = ColorWhite;
    self.followLabel.font = Font8;
    [self.followLabel sizeToFit];
    [self.frontPriceLabel sizeToFit];
    [self.priceBackView sizeToFit];
    [self.priceDriftView sizeToFit];
    
    self.stateLabel.textColor = ColorGray;
    self.stateLabel.font = Font10;
    self.stateLabel.text = TEXT(@"距开枪还剩");
    [self.stateLabel sizeToFit];
    self.saleNumLabel.textColor = ColorGray;
    self.saleNumLabel.font = Font8;
    
    LYFreeTimingPlate *plate = [LYFreeTimingPlate nib];
    plate.backgroundColor = [UIColor clearColor];
    [plate updateMinusWhioutBorderPlate];
    [self.stateBackView addSubview:plate];
    [plate autoSetDimension:ALDimensionHeight toSize:14];
    [plate autoSetDimension:ALDimensionWidth toSize:61];
    [plate autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.stateBackView withOffset:-16];
    [plate autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.stateLabel withOffset:6];
    self.timingPlate = plate;
}

- (CGFloat)getViewHeight {
    return 54.0f;
}

- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice tips:(NSString *)tips follow:(NSString *)follow {
    self.realPriceLabel.text = realPrice;
    self.frontPriceLabel.attributedText = frontPrice;
    self.saleNumLabel.text = tips;
    self.followLabel.text = follow;
    [self.realPriceLabel sizeToFit];
    [self.frontPriceLabel sizeToFit];
    [self.followLabel sizeToFit];
    [self.priceDriftView sizeToFit];
    self.pirceBackWidth.constant = WIDTH(self.realPriceLabel)+MAX(WIDTH(self.frontPriceLabel), WIDTH(self.followLabel));
}

- (void)updateWith:(NSDate *)countDownDate countdownToLastSeconds:(NSInteger)countdownToLastSeconds {
    self.timingPlate.date = countDownDate;
    self.timingPlate.countdownToLastSeconds = countdownToLastSeconds;
}

@end
