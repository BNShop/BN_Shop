//
//  BN_ShopGoodDetailNewArrivalsViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailNewArrivalsViewModel.h"

@implementation BN_ShopGoodDetailNewArrivalsModel

@end

@implementation BN_ShopGoodDetailNewArrivalsViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrivals = [[NSMutableArray alloc] initFromNet];
        self.dataSource = [[TableDataSource alloc] initWithItems:self.arrivals cellIdentifier:nil configureCellBlock:nil];
        self.title = TEXT(@"相关推荐");
        self.subTitle = TEXT(@" | New Arrivals");
    }
    return self;
}


#pragma mark - 获取提问列表
- (void)getNewArrivalsClearData:(BOOL)clear goodsId:(long)goodsId
{
//    int curPage = clear == YES ? 0 : round(self.arrivals.count/10.0);
    NSDictionary *paraDic = nil;//@{
//                              @"goodsId" : @(goodsId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsRecommendList?goodsId=%ld",BASEURL, goodsId];
    __weak typeof(self) temp = self;
    self.arrivals.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodDetailNewArrivalsModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear == YES)
            {
                [temp.arrivals removeAllObjects];
            }
            
            [temp.arrivals addObjectsFromArray:returnArray];
            temp.arrivals.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.arrivals.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.arrivals.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}


@end
