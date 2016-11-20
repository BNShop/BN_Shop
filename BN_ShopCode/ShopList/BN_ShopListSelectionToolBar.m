//
//  BN_ShopListSelectionToolBar.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopListSelectionToolBar.h"
#import "QRadioButton.h"
#import "V_LineLayer.h"

@interface BN_ShopListSelectionToolBar () <QRadioButtonDelegate, BN_ShopListSelectionToolBarProtocol>
@property (weak, nonatomic) IBOutlet QRadioButton *generalButton;
@property (weak, nonatomic) IBOutlet QRadioButton *salesButton;
@property (weak, nonatomic) IBOutlet QRadioButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) V_LineLayer *v_lineLayer;
@end

@implementation BN_ShopListSelectionToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.generalButton.groupId = @"ShopListSelection";
    [self.generalButton setTitle:TEXT(@"综合") forState:UIControlStateNormal];
    [self.generalButton setTitle:TEXT(@"综合") forState:UIControlStateSelected];
    [self.generalButton setImage:nil forState:UIControlStateNormal];
    [self.generalButton setImage:nil forState:UIControlStateSelected];
    [self.generalButton setTitleColor:ColorGray forState:UIControlStateNormal];
    [self.generalButton setTitleColor:ColorBtnYellow forState:UIControlStateSelected];
    [self.generalButton setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
    self.generalButton.titleLabel.font = Font12;
    self.generalButton.delegate = self;
    self.generalButton.tag = 0;
    
    self.salesButton.groupId = @"ShopListSelection";
    [self.salesButton setTitle:TEXT(@"销量") forState:UIControlStateNormal];
    [self.salesButton setTitle:TEXT(@"销量") forState:UIControlStateSelected];
    [self.salesButton setImage:nil forState:UIControlStateNormal];
    [self.salesButton setImage:nil forState:UIControlStateSelected];
    [self.salesButton setTitleColor:ColorGray forState:UIControlStateNormal];
    [self.salesButton setTitleColor:ColorBtnYellow forState:UIControlStateSelected];
    [self.salesButton setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
    self.salesButton.titleLabel.font = Font12;
    self.salesButton.delegate = self;
    self.salesButton.tag = 1;
    
    self.priceButton.groupId = @"ShopListSelection";
    [self updatePriceButtonWith:YES];
    [self.priceButton setImage:nil forState:UIControlStateNormal];
    [self.priceButton setImage:nil forState:UIControlStateSelected];
    [self.priceButton setTitleColor:ColorGray forState:UIControlStateNormal];
    [self.priceButton setTitleColor:ColorBtnYellow forState:UIControlStateSelected];
    [self.priceButton setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
    self.priceButton.titleLabel.font = Font12;
    self.priceButton.delegate = self;
    self.priceButton.tag = 2;
    
    
    [self.generalButton setChecked:YES];
    
    [self.filterButton setTitle:TEXT(@"筛选") forState:UIControlStateNormal];
    [self.filterButton setTitleColor:ColorGray forState:UIControlStateNormal];
    [self.filterButton setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
    self.filterButton.titleLabel.font = Font12;
    self.filterButton.tag = 0;
    
    
    self.v_lineLayer = [[V_LineLayer alloc] init];
    [self.v_lineLayer setStrokeColorWith:ColorLine];
    [self.v_lineLayer setLineTHWidth:1.0f];
    [self updateVLineWith:NO];
    [[self layer] addSublayer:self.v_lineLayer];
    
}

- (CGFloat)getViewHeight {
    return 40.0f;
}

- (void)updatePriceButtonWith:(BOOL)desc {
    NSString *title = desc ? TEXT(@"价格▽") : TEXT(@"价格△");
    [self.priceButton setTitle:title forState:UIControlStateNormal];
    [self.priceButton setTitle:title forState:UIControlStateSelected];
}

- (void)updateVLineWith:(BOOL)isV_Line {
    if (isV_Line) {
        [self.v_lineLayer setLineWidth:X(self.filterButton)+WIDTH(self.filterButton)/2.0-6 vWidth:12 vHeight:5];
    } else {
        [self.v_lineLayer setLineWidth:0 vWidth:0 vHeight:0];
    }
    [self.v_lineLayer v_LineWith:CGRectMake(0, [self getViewHeight]-0.5, WIDTH(self), 1)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)filterAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didFiltedTag:)]) {
        [_delegate didFiltedTag:[(UIButton *)sender tag]];
    }
}

//QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio prevChecked:(QRadioButton *)prevRadio  groupId:(NSString *)groupId {
    if ([_delegate respondsToSelector:@selector(didRadioTag:prevTag:groupId:)]) {
        NSInteger prevTag = prevRadio.tag;
        if (prevRadio == nil) {
            prevTag = -1;
        }
        [_delegate didRadioTag:radio.tag prevTag:prevTag groupId:groupId];
    }
}
@end


@implementation BN_ShopListSelectionToolBar (RAC)


- (RACSignal *)rac_radioTagSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(didRadioTag:prevTag:groupId:) fromProtocol:@protocol(BN_ShopListSelectionToolBarProtocol)] map:^id(RACTuple *tuple) {
        return tuple.allObjects;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_filterSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    
    signal = [[self rac_signalForSelector:@selector(didFiltedTag:) fromProtocol:@protocol(BN_ShopListSelectionToolBarProtocol)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}


@end



