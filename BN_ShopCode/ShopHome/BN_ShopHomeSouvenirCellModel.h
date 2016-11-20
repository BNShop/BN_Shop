//
//  BN_ShopHomeSouvenirCellModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopHomeSouvenirCellModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;

- (NSString *)thumbnailUrl;
- (NSString *)title;

@end
