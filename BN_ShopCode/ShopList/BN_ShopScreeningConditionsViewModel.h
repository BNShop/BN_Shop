//
//  BN_ShopScreeningConditionsViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"

@interface BN_ShopScreeningConditionsViewModel : NSObject
@property (nonatomic, strong, readonly) MultipleSectionTableArraySource *dataSource;

@property (nonatomic, copy) NSString *priceStart;
@property (nonatomic, copy) NSString *priceEnd;
@property (nonatomic, assign) NSUInteger tagID;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, strong) NSArray *suitable;

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (NSArray *)curIndexsInScreening;
- (void)curBankNameWith:(NSIndexPath *)indexPath;
- (void)curTagIDNameWith:(NSIndexPath *)indexPath;
- (void)curSuitableWith:(NSArray *)indexPaths;
@end
