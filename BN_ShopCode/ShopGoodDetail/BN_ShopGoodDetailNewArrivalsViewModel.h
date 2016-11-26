//
//  BN_ShopGoodDetailNewArrivalsViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopGoodDetailNewArrivalsViewModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@end
