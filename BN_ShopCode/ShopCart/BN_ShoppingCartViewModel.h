//
//  BN_ShoppingCartViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "BN_ShoppingCartItemProtocol.h"

@interface BN_ShoppingCartViewModel : NSObject

@property (nonatomic, strong, readonly) MultipleSectionTableArraySource *dataSource;
@property (assign, nonatomic, getter=isEdit) BOOL edit;

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray <BN_ShoppingCartItemProtocol>*)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)clearSelectedItems;
- (NSArray *)settlementSelectedItems;

- (NSAttributedString *)settlementCount;
- (NSString *)selectedItemPriceShow;
- (void)selectAll:(BOOL)isSelectedAll;
@end
