//
//  LBB_SaleafterModel.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_SaleafterModel.h"


@implementation LBB_SaleafterTypeModel


@end


@implementation LBB_SaleafterTypeViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

/**
 *3.6.6 售后原因列表
 */
- (void)getSaleafterType
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/dictList?classes=saleafter_type",BASEURL];
    
    __weak typeof(self) weakSelf = self;
    self.dataArray.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [LBB_SaleafterTypeModel mj_objectArrayWithKeyValuesArray:array];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:returnArray];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.dataArray.networkTotal = [dic objectForKey:@"total"];
        weakSelf.dataArray.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.dataArray.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

@end
