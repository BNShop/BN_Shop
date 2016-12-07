//
//  LBB_OrderHeaderView.m
//  ST_Travel
//
//  Created by 美少男 on 16/10/26.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderHeaderView.h"
#import "LBB_OrderHeader.h"


@interface LBB_OrderHeaderView()
@property (assign,nonatomic) OrderViewType stateType;
@end

@implementation LBB_OrderHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.numTipsLabel.textColor = ColorGray;
    self.numLabel.textColor = ColorGray;
    self.stateLabel.textColor = ColorBtnYellow;
    
    self.numTipsLabel.font = Font15;
    self.numLabel.font = Font15;
    self.stateLabel.font = Font15;
    self.lineView.backgroundColor = ColorLine;
}

- (void)setCellInfo:(LBB_OrderModelData*)cellInfo
{
    self.numLabel.text = cellInfo.order_no;
    self.stateLabel.text = cellInfo.order_state_name;
}


@end
