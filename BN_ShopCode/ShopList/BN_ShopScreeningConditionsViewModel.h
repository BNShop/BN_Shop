//
//  BN_ShopScreeningConditionsViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "BN_ShopConditionTagModel.h"

@interface BN_ShopScreeningConditionsViewModel : NSObject
@property (nonatomic, strong, readonly) MultipleSectionTableArraySource *dataSource;
@property (nonatomic, strong) NSMutableArray<BN_ShopConditionModel*> *conditions;

@property (nonatomic, assign) long suitTagId;//适合人群id
@property (nonatomic, assign) long brandTagId;//品牌id
@property (nonatomic, assign) long priceTagId;//价格id

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)buildConditionsWith:(int)classes;
- (void)getConditionTagsWith:(BN_ShopConditionModel *)condition;

- (NSInteger)curTagIndexWith:(int)type tagId:(long)tagId;
- (NSInteger)curBankIndex;
- (NSInteger)curSuitIndex;
- (NSInteger)curPriceIndex;

- (void)curBankTagIdWith:(NSIndexPath *)indexPath;
- (void)curPriceTagIdWith:(NSIndexPath *)indexPath;
- (void)curSuitTagIdWith:(NSIndexPath *)indexPath;
@end
