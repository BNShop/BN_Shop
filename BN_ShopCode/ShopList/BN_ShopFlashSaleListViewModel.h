//
//  BN_ShopFlashSaleListViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopGoodModel.h"

@interface BN_ShopFlashSaleListViewModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray <BN_ShopGoodModel*> *goods;

- (void)getLimiteGoodsClearData:(BOOL)clear;
- (void)cancelTimer;
@end
