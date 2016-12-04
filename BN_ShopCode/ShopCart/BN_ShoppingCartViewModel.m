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
#import "NSError+Description.h"


@interface BN_ShoppingCartViewModel ()

@end

@implementation BN_ShoppingCartItemModel

@end

@implementation BN_ShoppingCartViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shoppingCartList = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
    
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
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_ShoppingCartItemModel *obj) {
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
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_ShoppingCartItemModel *obj) {
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
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_ShoppingCartItemModel *obj) {
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
        [sectionDataSource.items bk_each:^(BN_ShoppingCartItemModel *obj) {
            if ([obj isSelected]) {
                price += [obj num] * [[obj real_price] floatValue] - (obj.free_shipping_status*[obj.free_shipping_amount floatValue]);
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
        [sectionDataSource.items bk_each:^(BN_ShoppingCartItemModel *obj) {
            [obj  setSelected:isSelectedAll];
        }];
        
    }];

}

#pragma mark - 购物车列表获取
- (void)getShoppingCartListData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.shoppingCartList.count/10.0);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:curPage], @"curPage", [NSNumber numberWithInt:10], @"pageNum", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/shoppingCartList",BASEURL];
    __weak typeof(self) temp = self;
    self.shoppingCartList.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShoppingCartItemModel mj_objectArrayWithKeyValuesArray:array];
            [returnArray bk_each:^(BN_ShoppingCartItemModel *obj) {
                obj.selected = YES;
            }];
            if (clear == YES)
            {
                temp.dataSource = [[MultipleSectionTableArraySource alloc] init];
                [temp.shoppingCartList removeAllObjects];
            }
            
            [temp.shoppingCartList addObjectsFromArray:returnArray];
            temp.shoppingCartList.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.shoppingCartList.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.shoppingCartList.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

- (void)deleteShoppingCart:(NSArray *)shoppingCartIds success:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSString *shoppingCartIdsStr = [shoppingCartIds componentsJoinedByString:@","];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"shoppingCartIds"] = shoppingCartIdsStr;
//    if ([BC_ToolRequest sharedManager].token) {
//        paraDic[@"token"] = [BC_ToolRequest sharedManager].token;
//    }
    NSString *url = [NSString stringWithFormat:@"%@/mall/deleteShoppingCart",BASEURL];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            if (success) {
                success();
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

@end
