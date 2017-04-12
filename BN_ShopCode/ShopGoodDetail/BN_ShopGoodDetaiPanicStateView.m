//
//  BN_ShopGoodDetaiPanicStateView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetaiPanicStateView.h"
#import "LYFreeTimingPlate.h"
#import "PureLayout.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetaiPanicStateView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pirceBackWidth;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;
@property (strong, nonatomic) LYFreeTimingPlate *timingPlate;
@property (weak, nonatomic) IBOutlet UIView *priceBackView;
@property (weak, nonatomic) IBOutlet UIView *stateBackView;
@property (weak, nonatomic) IBOutlet UIView *priceDriftView;

@end

@implementation BN_ShopGoodDetaiPanicStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceBackView.backgroundColor = ColorBtnYellow;
    self.stateBackView.backgroundColor = ColorBackground;
    self.realPriceLabel.textColor = ColorWhite;
    self.realPriceLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.realPriceLabel sizeToFit];
    self.frontPriceLabel.textColor = ColorWhite;
    self.frontPriceLabel.font = Font10;
    [self.frontPriceLabel sizeToFit];
    [self.priceBackView sizeToFit];
    [self.priceDriftView sizeToFit];
    
    self.stateLabel.textColor = ColorGray;
    self.stateLabel.font = Font10;
    self.stateLabel.text = TEXT(@"距结束还剩");
    [self.stateLabel sizeToFit];
    self.residueLabel.textColor = ColorGray;
    self.residueLabel.font = Font8;
    [self.residueLabel sizeToFit];
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

- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice saleNum:(NSString *)saleNum residue:(NSString *)residue {
    self.realPriceLabel.text = realPrice;
    self.frontPriceLabel.attributedText = frontPrice;
    self.saleNumLabel.text = saleNum;
    self.residueLabel.text = residue;
    [self.realPriceLabel sizeToFit];
    [self.frontPriceLabel sizeToFit];
    [self.priceDriftView sizeToFit];
    self.pirceBackWidth.constant = WIDTH(self.realPriceLabel)+WIDTH(self.frontPriceLabel);
}

- (void)updateWith:(NSDate *)countDownDate countdownToLastSeconds:(NSInteger)countdownToLastSeconds {
    self.timingPlate.date = countDownDate;
    self.timingPlate.countdownToLastSeconds = countdownToLastSeconds;
}

@end
