//
//  BN_ShopSorterViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSorterViewModel.h"

@interface BN_ShopSorterViewModel ()

@property (nonatomic, strong) TableDataSource *titleDataSource;
@property (nonatomic, strong) NSMutableArray *sorterDataSources;//里面也是TableDataSource

@end

@implementation BN_ShopSorterViewModel

- (instancetype)init {
    if (self = [super init]) {
        _selectionIndex = -1;
    }
    return self;
}


- (void)setSelectionIndex:(NSInteger)selectionIndex {
//    if (_selectionIndex != selectionIndex) {
//        _selectionIndex = selectionIndex;
//        if ([_sorterDataSources count] <= _selectionIndex || _selectionIndex < 0) {
//            _selectionDataSource = nil;
//#warning 去获取新的对应类型的数据
//        } else {
//            _selectionDataSource = [_sorterDataSources objectAtIndex:selectionIndex];
//            if ([_selectionDataSource isEqual:[NSNull null]]) {
//                _selectionDataSource = nil;
//#warning 去获取新的对应类型的数据
//            }
//        }
//    }
}


- (TableDataSource *)getTitleDataSourceWith:(NSArray *)titles
                             cellIdentifier:(NSString *)aCellIdentifier
                         configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock{
    if (!_titleDataSource) {
        _titleDataSource = [[TableDataSource alloc] initWithItems:titles cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    } else {
        [_titleDataSource resetItems:titles cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    }
    return _titleDataSource;
}


- (TableDataSource *)getSectionDataSourceWith:(NSArray *)sections
                             cellIdentifier:(NSString *)aCellIdentifier
                         configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock{
    if (!_selectionDataSource) {
        _selectionDataSource = [[TableDataSource alloc] initWithItems:sections cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    } else {
        [_selectionDataSource resetItems:sections cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    }
    return _selectionDataSource;
}

- (NSMutableArray *)sorterDataSources {
    if (!_sorterDataSources) {
        _sorterDataSources = [NSMutableArray array];
    }
    return _sorterDataSources;
}


#pragma mark - 获取titles的数据


#pragma mark - 获取对应的section的数据

@end
