//
//  BN_ShopGoodDetailConsultancyViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailConsultancyViewModel.h"
#import "NSError+Description.h"

@interface BN_ShopGoodDetailConsultancyViewModel ()



@end

@implementation BN_ShopGoodDetailConsultancyViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] initFromNet];
        self.dataSource = [[TableDataSource alloc] initWithItems:self.items cellIdentifier:nil configureCellBlock:nil];
    }
    return self;
}

#pragma mark - 发送提问请求
- (void)sendConsultingWith:(NSString *)text failure:(void(^)(NSString *errorStr))failure{
    NSDictionary *paraDic = @{
                              @"goodsId":[NSNumber numberWithLong:self.goodsId],
                              @"question":text
                              };
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/consulting",BASEURL];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

#pragma mark - 获取提问列表
- (void)getAnswersListClearData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.items.count/10.0);
    NSDictionary *paraDic = @{@"curPage" : [NSNumber numberWithInt:curPage],
                              @"pageNum" : [NSNumber numberWithInt:10],
                              @"goodsId" : [NSNumber numberWithLong:self.goodsId]};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/answersList",BASEURL];
    __weak typeof(self) temp = self;
    self.items.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodDetailConsultancyModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear == YES)
            {
                [temp.items removeAllObjects];
            }
            
            [temp.items addObjectsFromArray:returnArray];
            temp.items.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.items.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.items.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}


@end
