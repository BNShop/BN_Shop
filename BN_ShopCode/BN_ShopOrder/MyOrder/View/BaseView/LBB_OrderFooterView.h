//
//  LBB_OrderFooterView.h
//  ST_Travel
//
//  Created by 美少男 on 16/10/26.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBB_OrderHeader.h"
#import "LBB_OrderModel.h"

@protocol LBB_OrderFooterViewDelegate <NSObject>

@optional
- (void)cellBtnClickDelegate:(LBB_OrderModelData*)cellInfo
             TicketClickType:(OrderClickType)clickType;

@end

@interface LBB_OrderFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totoalTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;//运费
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgLine1;
@property (weak, nonatomic) IBOutlet UIView *bgLine2;

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) id<LBB_OrderFooterViewDelegate> mDelegate;

@property(nonatomic,strong) LBB_OrderModelData* cellInfo;

@end
