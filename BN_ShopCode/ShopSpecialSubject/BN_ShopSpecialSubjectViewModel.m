//
//  BN_ShopSpecialSubjectViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectViewModel.h"


@implementation BN_ShopSpecialSubjectViewModel

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}


@end
