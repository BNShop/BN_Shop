//
//  LBB_SaleafterModel.h
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBB_SaleafterTypeModel:BN_BaseDataModel

@property(nonatomic,copy) NSString *display ;//显示名称
@property(nonatomic,assign) int value;//值

@end

@interface LBB_SaleafterTypeViewModel : BN_BaseDataModel

@property(nonatomic,strong) NSMutableArray<LBB_SaleafterTypeModel*> *dataArray;

/**
 *3.6.6 售后原因列表
 */
- (void)getSaleafterType;

@end
