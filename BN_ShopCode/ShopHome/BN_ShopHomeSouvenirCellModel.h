//
//  BN_ShopHomeSouvenirCellModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopSouvenirModel.h"
#import "BN_ShopHeader.h"



@interface BN_ShopHomeSouvenirCellModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) BN_ShopSouvenirModel *souvenirModel;

- (NSString *)thumbnailUrl;
- (NSString *)title;

@end
