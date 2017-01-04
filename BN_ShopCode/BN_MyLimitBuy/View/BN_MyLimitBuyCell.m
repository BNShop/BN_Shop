//
//  BN_MyLimitBuyCell.m
//  BN_Shop
//
//  Created by yuze_huang on 2017/1/1.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import "BN_MyLimitBuyCell.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"
#import "BN_ShopHeader.h"
#import "LYFreeTimingPlate.h"
#import "UIControl+BlocksKit.h"
#import "PureLayout.h"

@interface BN_MyLimitBuyCell ()
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *snappedBtn;
@property (strong, nonatomic) LYFreeTimingPlate *timingPlate;
@property (weak,nonatomic) IBOutlet UILabel *coverLabel;// 提示膜层

@end

@implementation BN_MyLimitBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.bottomLineView.backgroundColor = ColorLine;
    self.oldPrice.textColor = ColorBlack;
    self.oldPrice.font = Font12;
    self.thumbnailImageView.q_BorderColor = ColorLine;
    self.thumbnailImageView.q_BorderWidth = 1.0f;
    self.snappedBtn.titleLabel.font = Font14;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverLabel.hidden = YES;
    self.coverLabel.font = Font16;
    self.coverLabel.backgroundColor = RGBAHEX(0x626262, 0.7);
    self.coverLabel.textColor = [UIColor whiteColor];
    self.coverLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.coverLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewWithModel:(BN_MycollectionModel *)model
{
    self.radioButton.selected = !model.selected;
    self.radioButton.hidden = !model.isEdit;
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:nil];
    self.titleLabel.text = model.name;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", model.real_price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:8.0],NSForegroundColorAttributeName:[UIColor lightGrayColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
    
    self.oldPrice.attributedText = attrStr;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.real_price];
    [self.snappedBtn setTitle:@"取消提醒" forState:UIControlStateSelected];
    [self.snappedBtn setTitle:@"设置提醒" forState:UIControlStateNormal];
    if (model.buying_state == 0) { // 0未开始 1抢购中 2已结束
        if (model.warn_id) {
            self.snappedBtn.backgroundColor = ColorBtnYellow;
            self.snappedBtn.selected = model.warn_id;
        }
        self.leftTimeLabel.textColor = ColorBtnYellow;
    }else {
        self.snappedBtn.selected = NO;
        [self.snappedBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        self.snappedBtn.backgroundColor = ColorRed;
        self.leftTimeLabel.textColor = ColorRed;
        if (model.avail_buying_num == 0) {
            self.coverLabel.hidden = NO;
            self.coverLabel.text = @"无货";
        }
        if (model.cur_state == 0) {
            self.coverLabel.hidden = NO;
            self.coverLabel.text = @"商品已下架";
        }
        
        if (model.buying_state == 2) {
            self.coverLabel.hidden = NO;
            self.coverLabel.text = @"抢购结束";
        }
    }
    self.leftTimeLabel.text = model.timerStr;
}

- (void)buildTimePlate {
    if (!self.timingPlate) {
        LYFreeTimingPlate *plate = [LYFreeTimingPlate nib];
        plate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:plate];
        [plate autoSetDimension:ALDimensionHeight toSize:14];
        [plate autoSetDimension:ALDimensionWidth toSize:61];
        [plate autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.thumbnailImageView withOffset:120];
        [plate autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.leftTimeLabel withOffset:8];
        self.timingPlate = plate;
    }
    
}

- (void)updateAdditionalForward:(NSDate *)date state:(int)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftTimeLabel.textColor = ColorBtnYellow;
        self.leftTimeLabel.font = Font12;
        self.snappedBtn.backgroundColor = ColorBtnYellow;
        if (state == -1) {
            [self.snappedBtn setTitle:TEXT(@"设置提醒") forState:UIControlStateNormal];
        } else {
            [self.snappedBtn setTitle:TEXT(@"取消提醒") forState:UIControlStateNormal];
        }
        [self.snappedBtn setNeedsDisplay];
        self.leftTimeLabel.text = TEXT(@"距离开始时间");
        [self.timingPlate updateMinusWhioutBorderPlate:ColorBtnYellow];
        
        self.timingPlate.date = date;
    });
    
}

- (void)updateAdditionalFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftTimeLabel.textColor = ColorLightGray;
        self.leftTimeLabel.font = Font12;
        self.snappedBtn.backgroundColor = ColorLightGray;
        [self.snappedBtn setTitle:TEXT(@"已结束") forState:UIControlStateNormal];
        [self.snappedBtn setNeedsDisplay];
        self.leftTimeLabel.text = TEXT(@"抢购已结束");
        [self.timingPlate updateMinusWhioutBorderPlate:ColorLightGray];
        self.timingPlate.date = nil;
    });
}

- (void)updateAdditionalFrenzied:(NSDate *)date {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftTimeLabel.textColor = ColorRed;
        self.leftTimeLabel.font = Font12;
        self.snappedBtn.backgroundColor = ColorRed;
        [self.snappedBtn setTitle:TEXT(@"立即抢购") forState:UIControlStateNormal];
        [self.snappedBtn setNeedsDisplay];
        self.leftTimeLabel.text = TEXT(@"距离结束时间");
        [self.timingPlate updateMinusWhioutBorderPlate:ColorRed];
        self.timingPlate.date = date;
    });
}

- (void)addManageButtonEvent:(void (^)(id sender))handler {
    if ([self.snappedBtn.titleLabel.text isEqualToString:@"立即抢购"]) {
        
    }else {
        self.snappedBtn.hidden = NO;
        [self.snappedBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [self.snappedBtn bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)cancelTimer {
    [self.timingPlate cancelTimer];
}

- (IBAction)selectAction:(id)sender {
    self.radioButton.selected = !self.radioButton.isSelected;
    if ([_delegate respondsToSelector:@selector(selectActionWith:selected:)]) {
        [_delegate selectActionWith:self selected:self.radioButton.selected];
    }
}

#pragma mark - stepper's value changed
- (void)valueChanged:(float)count {
    if ([_delegate respondsToSelector:@selector(valueChangedWith:count:)]) {
        [_delegate valueChangedWith:self count:count];
    }
}

@end
