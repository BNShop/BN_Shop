//
//  LBB_ApplyAalesViewController.h
//  BN_Shop
//  申请售后
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderBaseViewController.h"
#import "LBB_OrderModel.h"

typedef void(^ApplyAalesBlock)(BOOL result);

@interface LBB_ApplyAalesViewController : LBB_OrderBaseViewController

@property(nonatomic,strong) ApplyAalesBlock completeBlock;
@property(nonatomic,strong) LBB_OrderModelData *orderViewModel;

@end
