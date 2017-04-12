//
//  BN_ShopHomeViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopHomeSouvenirCellModel.h"
#import "BN_ShopHeader.h"



@interface BN_ShopHomeViewModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray<BN_ShopSouvenirModel*> *souvenirs;

- (void)getSouvenirsData;
@end
