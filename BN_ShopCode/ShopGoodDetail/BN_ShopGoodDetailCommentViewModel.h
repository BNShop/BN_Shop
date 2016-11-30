//
//  BN_ShopGoodDetailCommentViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopGoodCommentsModel.h"

@interface BN_ShopGoodDetailCommentViewModel : NSObject

@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray<BN_ShopGoodCommentsModel*> *items;
@property (nonatomic, assign) long objId;//商品id
@property (nonatomic, assign) int type;//4:伴手礼 14:伴手礼专题
@property (nonatomic, assign) int avg_score;//平均评分

- (NSString *)avgort;
- (void)getCommentsClearData:(BOOL)clear;

@end
