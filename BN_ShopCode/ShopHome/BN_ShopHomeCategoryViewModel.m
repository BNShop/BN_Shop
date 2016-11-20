//
//  BN_ShopHomeCategoryViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeCategoryViewModel.h"

@interface BN_ShopHomeCategoryViewModel ()

@property (strong, nonatomic) NSArray *categorys;

@end

@implementation BN_ShopHomeCategoryViewModel

- (instancetype)initWith:(NSArray *)items {
    if (self = [super init]) {
        _categorys = items;
    }
    return self;
}

- (void)initCategorysWith:(NSArray *)items {
    self.categorys = items;
}

- (id)categoryWithIndex:(NSInteger)index {
    if (index >= [self.categorys count] || index < 0)
        return nil;
    NSArray *tmpItems = [self.categorys copy];
    return tmpItems[index];
}

- (NSArray *)categoryTitles {
    #warning 将数据加入
    NSMutableArray *titles = [NSMutableArray array];
//    for (id obj in self.categorys) {
//
//    }
    return @[@"分类", @"台湾伴手礼", @"厦门伴手礼", @"其他伴手礼"];
    return titles.copy;
}
@end
