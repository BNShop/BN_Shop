//
//  BN_ShopScreeningConditionsViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningConditionsViewModel.h"

@interface BN_ShopScreeningConditionsViewModel ()

@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;

@end

@implementation BN_ShopScreeningConditionsViewModel


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
        SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
        sectionDataSource.cellIdentifier = cellIdentifier;
        sectionDataSource.configureCellBlock = configureCellBlock;
        sectionDataSource.configureSectionBlock = configureSectionBlock;
        sectionDataSource.sectionIdentifier = sectionIdentifier;
        
        return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}

#pragma mark - 选中的标签
- (NSArray *)curIndexsInScreening {
    return @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:0 inSection:3], [NSIndexPath indexPathForRow:2 inSection:3]];
}

#warning 获取当前的赌赢配置
- (void)curBankNameWith:(NSIndexPath *)indexPath {
//    id obj = [self.dataSource itemAtIndexPath:indexPath];
    self.brandName = @"不限";
}

- (void)curTagIDNameWith:(NSIndexPath *)indexPath {
//    id obj = [self.dataSource itemAtIndexPath:indexPath];
    self.tagID = 0;
}

- (void)curSuitableWith:(NSArray *)indexPaths {
//    id obj = [self.dataSource itemAtIndexPath:indexPath];
    self.suitable = @[@"A", @"B"];
}

@end
