//
//  BN_ShopListViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopListViewModel.h"
#import "BN_ShopHeader.h"

@interface BN_ShopListViewModel ()
@property (nonatomic, strong) TableDataSource *dataSource;
//排序的情况选择
@property (nonatomic, copy) NSString *order;//排序字段(‘out_buying_num’，‘real_price’)
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *priceStart;//价格起始
@property (nonatomic, copy) NSString *priceEnd;//价格结束

@end

static NSString * const BN_ShopListSortDesc = @"desc";
static NSString * const BN_ShopListSortAsc = @"asc";

static NSString * const BN_ShopListSortOrderPrice = @"real_price";
static NSString * const BN_ShopListSortOrderSales = @"out_buying_num";
static NSString * const BN_ShopListSortOrderComposite = @"";


@implementation BN_ShopListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.order = BN_ShopListSortOrderComposite;
        self.sort = BN_ShopListSortDesc;
        self.goodsName = @"";
        self.goods = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (TableDataSource *)getDataSourceWith:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    self.dataSource = [[TableDataSource alloc] initWithItems:self.goods cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
    return _dataSource;
}

- (void)addDataSourceWith:(NSArray *)items {
    [self.dataSource addItems:items];
}


- (void)setOrderWith:(NSInteger)radioIndex{
    switch (radioIndex) {
        case 1:
            self.order = BN_ShopListSortOrderSales;//销量
            break;
        case 2:
            if ([self.order isEqualToString:BN_ShopListSortOrderPrice]) {//就等于价格，则进行反转
                if ([self isDesc]) {
                    self.sort = BN_ShopListSortAsc;
                } else {
                    self.sort = BN_ShopListSortDesc;
                }
            }
            self.order = BN_ShopListSortOrderPrice;
            break;
            
        default:
            self.order = BN_ShopListSortOrderComposite;//综合
            break;
    }
}

- (BOOL)isDesc {
    return [self.sort isEqualToString:BN_ShopListSortDesc];
}

- (NSString *)total_commentStr:(int)total_comment {
    return [NSString stringWithFormat:@"%d%@", total_comment, TEXT(@"条评论")];
}

#pragma mark - 数据获取


- (void)getGoodsClearData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.goods.count/10.0);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:curPage], @"curPage", [NSNumber numberWithInt:10], @"pageNum", nil];
    if (self.order.length) {
        [paraDic setObject:self.order forKey:@"order"];
        [paraDic setObject:self.sort forKey:@"sort"];
    }
    if (self.goodsName.length) {
        [paraDic setObject:self.goodsName forKey:@"goodsName"];
    }
    if (self.priceTagId) {
        [paraDic setObject:[NSNumber numberWithLong:self.priceTagId] forKey:@"priceTagId"];
    }
    if (self.suitTagId) {
        [paraDic setObject:[NSNumber numberWithLong:self.suitTagId] forKey:@"suitTagId"];
    }
    if (self.brandTagId) {
        [paraDic setObject:[NSNumber numberWithLong:self.brandTagId] forKey:@"brandTagId"];
    }
    if (self.categoryId) {
        [paraDic setObject:[NSNumber numberWithLong:self.categoryId] forKey:@"categoryId"];
    }

    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsListForFilter", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.goods.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear == YES)
            {
                [temp.goods removeAllObjects];
            }
            
            [temp.goods addObjectsFromArray:returnArray];
            temp.goods.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.goods.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.goods.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}


@end
