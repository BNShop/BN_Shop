//
//  BN_ShopSearchViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"

@interface BN_ShopSearchViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong, readonly) MultipleSectionTableArraySource *dataSource;
- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title tagged:(id)tagged items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (NSArray *)getRecentlySearchCache;
- (NSArray *)getHotSearchCache;
- (void)cacheSearchs;
- (void)delSearchLocal;
- (void)addSearchToLocalWith:(NSString *)search;
- (void)resetSearchsToHotWith:(NSArray *)searchs;

- (id)validSearch:(NSIndexPath *)indexPath;

- (void)getHotSearchTagsDataRes;
@end
