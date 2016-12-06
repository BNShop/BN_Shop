//
//  BN_ShopHomeViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeViewModel.h"




@implementation BN_ShopHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.souvenirs = [[NSMutableArray alloc] initFromNet];
//        self.dataSource = [[TableDataSource alloc] initWithItems:self.souvenirs cellIdentifier:nil configureCellBlock:nil];
    }
    return self;
}

- (void)getSouvenirsData
{
    NSDictionary *paraDic = nil;// @{@"type":@1};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/categoryListForIndex?type=1",BASEURL];
    __weak typeof(self) temp = self;
    self.souvenirs.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopSouvenirModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.souvenirs removeAllObjects];
            
            [temp.souvenirs addObjectsFromArray:returnArray];
            temp.souvenirs.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.souvenirs.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.souvenirs.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

@end
