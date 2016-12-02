//
//  BN_ShoppingCartViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShoppingCartViewModel.h"
#import "NSDictionary+BlocksKit.h"
#import "NSArray+BlocksKit.h"
#import "NSString+Attributed.h"


@interface BN_ShoppingCartViewModel ()

@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;

@end

@implementation BN_ShoppingCartViewModel

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray <BN_ShoppingCartItemProtocol>*)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
    
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    sectionDataSource.configureSectionBlock = configureSectionBlock;
    sectionDataSource.sectionIdentifier = nil;
    
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}

//删除选中的选项
- (void)clearSelectedItems {
    __block NSMutableArray *matchs = [NSMutableArray array];
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(id<BN_ShoppingCartItemProtocol> obj) {
            return [obj isSelected];
        }];
        if (match) {
            [sectionDataSource deleteItemWithItems:match];
        }
        if (sectionDataSource.getItemsCount == 0) {
            [matchs addObject:sectionDataSource];
        }
    }];
    [self.dataSource.sections removeObjectsInArray:matchs];
}

- (NSArray *)settlementSelectedItems {
    __block NSMutableArray *matchs = [NSMutableArray array];
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(id<BN_ShoppingCartItemProtocol> obj) {
            return [obj isSelected];
        }];
        if (match) {
            [matchs addObjectsFromArray:match];
        }
    }];
    return matchs;
}

- (NSInteger)selectedItemCount {
    __block NSInteger count = 0;
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(id<BN_ShoppingCartItemProtocol> obj) {
            return [obj isSelected];
        }];
        count += [match count];
    }];

    return count;
}


- (NSAttributedString *)settlementCount {
    NSString *price = [NSString stringWithFormat:@"%@(%ld)", TEXT(@"结算"), (long)[self selectedItemCount]];
    return [price setFont:Font15 restFont:(UIFont *)Font10 range:[price rangeOfString:TEXT(@"结算")]];
}


- (NSString *)selectedItemPrice {
    
    __block CGFloat price = 0.0;
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        [sectionDataSource.items bk_each:^(id<BN_ShoppingCartItemProtocol> obj) {
            if ([obj isSelected]) {
                price += [obj num] * [[obj real_price] floatValue];
            }
        }];
        
    }];
    
    return [NSString stringWithFormat:@"%.2f", price];
}

- (NSString *)selectedItemPriceShow {
   return [NSString stringWithFormat:@"%@：¥%@", TEXT(@"合计"), [self selectedItemPrice]];
}

- (void)selectAll:(BOOL)isSelectedAll {
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        [sectionDataSource.items bk_each:^(id<BN_ShoppingCartItemProtocol> obj) {
            [obj  setSelected:isSelectedAll];
        }];
        
    }];

}

#pragma mark - 购物车列表获取

@end
