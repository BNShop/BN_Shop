//
//  LBB_OrderFooterView.m
//  ST_Travel
//
//  Created by 美少男 on 16/10/26.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderFooterView.h"

@interface LBB_OrderFooterView()
@property (assign,nonatomic) OrderViewType stateType;
@property (assign,nonatomic) OrderClickType clickType;
@property (assign,nonatomic) OrderClickType leftBtnClickType;
@property (assign,nonatomic) OrderClickType rightBtnClickType;

@end

@implementation LBB_OrderFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.goodNumLabel.textColor = ColorGray;
    self.totoalTipLabel.textColor = ColorGray;
    self.goodMoneyLabel.textColor = ColorRed;
    self.freightLabel.textColor = ColorLightGray;
    self.goodNumLabel.font = Font15;
    self.totoalTipLabel.font = Font15;
    self.goodMoneyLabel.font = Font15;
    self.freightLabel.font = Font13;
    
    self.leftBtn.backgroundColor = ColorLightGray;
    self.rightBtn.backgroundColor = ColorBtnYellow;
    [self.leftBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.leftBtn.titleLabel setFont:Font15];
    [self.rightBtn.titleLabel setFont:Font15];
    
    self.bgView.backgroundColor = ColorBackground;
    self.topLine.backgroundColor = ColorLine;
    self.bgLine1.backgroundColor = ColorLine;
    self.bgLine2.backgroundColor = ColorLine;
    self.leftBtnClickType = eOrderNone;
    self.rightBtnClickType = eOrderNone;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
}

- (void)setCellInfo:(LBB_OrderModelData*)cellInfo
{
    _cellInfo = cellInfo;
    self.goodNumLabel.text = [NSString stringWithFormat:@"共%@件商品",@(cellInfo.goods_num)];
    self.goodMoneyLabel.text = [NSString stringWithFormat:@"￥%@",cellInfo.goods_amount];
    self.freightLabel.text = [NSString stringWithFormat:@"(含运费￥%@)",cellInfo.freight_amount];
    [self setStateTypeWithCellInfo:cellInfo];
}

- (void)setStateTypeWithCellInfo:(LBB_OrderModelData*)cellInfo
{
//    0待付款1已付款2待收货3已完成10已取消
    _cellInfo = cellInfo;
    if (cellInfo.order_state == 0) {
        self.leftBtnClickType = eCancelOrder;
        self.rightBtnClickType = ePayOrder;
    }else if(cellInfo.order_state == 1){
        self.leftBtnClickType = eOrderNone;
        self.rightBtnClickType = eShowOrderDetail;
    }else if(cellInfo.order_state == 2){
        self.leftBtnClickType = eOrderNone;
        self.rightBtnClickType = eGetOrder;
    }else if(cellInfo.order_state == 3){
        if (cellInfo.comments_state == 0) {//0 未评价1已评价
            self.rightBtnClickType = eCommentOrder;
            if (cellInfo.saleafter_state == 0) { //售后状态0 未发起售后1申请中2 处理中3已完成
                self.leftBtnClickType = eApplyAales;
            }else {
                self.leftBtnClickType = eCheckAales;
            }
        }else{
            if (cellInfo.saleafter_state == 0) { //售后状态0 未发起售后1申请中2 处理中3已完成
                self.rightBtnClickType = eApplyAales;
            }else {
                self.rightBtnClickType = eCheckAales;
            }
        }
    }else if(cellInfo.order_state == 10) {
        self.leftBtnClickType = eOrderNone;
        self.rightBtnClickType = eDeleteOrder;
    }
    
    [self setBtnTitle:self.leftBtnClickType Btn:self.leftBtn];
    [self setBtnTitle:self.rightBtnClickType Btn:self.rightBtn];
}

- (void)setBtnTitle:(OrderClickType)clickType Btn:(UIButton*)btn
{
    btn.hidden = NO;
    switch (clickType) {
        case eOrderNone:
        {
            btn.hidden = YES;
            [btn setTitle:nil forState:UIControlStateNormal];
        }
            break;
        case eCancelOrder:
        {
            [btn setTitle:@"取消订单" forState:UIControlStateNormal];
        }
            break;
        case ePayOrder:
        {
            [btn setTitle:@"立即支付" forState:UIControlStateNormal];
        }
            break;
        case eShowOrderDetail:
        {
            [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case eGetOrder:
        {
            [btn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case eCommentOrder:
        {
            [btn setTitle:@"立即评价" forState:UIControlStateNormal];
        }
            break;
        case eDeleteOrder:
        {
            [btn setTitle:@"删除" forState:UIControlStateNormal];
        }
            break;
        case eCheckAales:
        {
            [btn setTitle:@"查看售后" forState:UIControlStateNormal];
        }
            break;
        case eApplyAales:
        {
            [btn setTitle:@"申请售后" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UI Action

- (IBAction)rightBtnAction:(id)sender {
    if (self.mDelegate &&
        [self.mDelegate respondsToSelector:@selector(cellBtnClickDelegate:TicketClickType:)]) {
        [self.mDelegate cellBtnClickDelegate:self.cellInfo
                             TicketClickType:self.rightBtnClickType];
    }
}

- (IBAction)leftBtnAction:(id)sender {
    
    if (self.mDelegate &&
        [self.mDelegate respondsToSelector:@selector(cellBtnClickDelegate:TicketClickType:)]) {
        [self.mDelegate cellBtnClickDelegate:self.cellInfo
                             TicketClickType:self.leftBtnClickType];
    }
}

@end
