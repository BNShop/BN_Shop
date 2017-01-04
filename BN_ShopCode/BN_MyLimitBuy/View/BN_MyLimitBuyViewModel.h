//
//  BN_MyLimitBuyViewModel.h
//  BN_Shop
//
//  Created by yuze_huang on 2017/1/3.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_MycollectionModel.h"
#import "MultipleSectionTableArraySource.h"
#import "BN_ShopHeader.h"

@interface BN_MyLimitBuyViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *collectionList;//购物车列表
@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;
@property (assign, nonatomic, getter=isEdit) BOOL edit;

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)clearSelectedItems;
- (NSArray *)settlementSelectedItems;

- (NSAttributedString *)settlementCount;
- (void)selectAll:(BOOL)isSelectedAll;

- (void)getCollectionListData:(BOOL)clear;
- (void)deletecollection:(NSArray *)collectionIds success:(void(^)())success failure:(void(^)(NSString *errorDescription))failure;
- (void)isEditCell:(BOOL)isEditCell;
// 设置提醒与否
- (void)warnORCancelRes:(BOOL)isWarn goodsId:(long)goodsId success:(void(^)(long warn_id))success failure:(void(^)(NSString *errorDescription))failure;

@end
