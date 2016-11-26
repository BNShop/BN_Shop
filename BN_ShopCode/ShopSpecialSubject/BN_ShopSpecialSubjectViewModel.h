//
//  BN_ShopSpecialSubjectViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"

@interface BN_ShopSpecialSubjectViewModel : NSObject
@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;
@property (nonatomic, assign) BOOL isFollow;


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

@end
