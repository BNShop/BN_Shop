//
//  LBB_OrderHeaderView.h
//  ST_Travel
//
//  Created by 美少男 on 16/10/26.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBB_OrderModel.h"

@interface LBB_OrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *numTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView  *lineView;

@property(nonatomic,strong) LBB_OrderModelData* cellInfo;


@end
