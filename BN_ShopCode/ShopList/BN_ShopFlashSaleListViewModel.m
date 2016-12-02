//
//  BN_ShopFlashSaleListViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopFlashSaleListViewModel.h"
#import "NSArray+BlocksKit.h"
#import "NSError+Description.h"


@interface BN_ShopFlashSaleListViewModel ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BN_ShopFlashSaleListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goods = [[NSMutableArray alloc] initFromNet];
        self.dataSource = [[TableDataSource alloc] initWithItems:self.goods cellIdentifier:nil configureCellBlock:nil];
    }
    return self;
}


- (void)getLimiteGoodsClearData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.goods.count/10.0);
    NSDictionary *paraDic = @{@"curPage" : @(curPage),
                              @"pageNum" : @10};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/buyingGoodsListForFilter",BASEURL];
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
        if (temp.goods.count > 0) {
            [temp resumeTimer];
        }
        temp.goods.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.goods.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

#pragma mark - 提醒与取消
- (void)warnORCancelRes:(BOOL)isWarn goodsId:(long)goodsId success:(void(^)(long))success failure:(void(^)(NSString *errorDescription))failure {
    NSDictionary *paraDic0 = @{
                               @"goodsId":[NSNumber numberWithLong:goodsId]
                               };
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if ([BC_ToolRequest sharedManager].token) {
        [paraDic setObject:[BC_ToolRequest sharedManager].token forKey:@"token"];
    }
    [paraDic setValuesForKeysWithDictionary:paraDic0];
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/warn", BASEURL];
    if (!isWarn) {
        url = [NSString stringWithFormat:@"%@/mall/cancelWarn", BASEURL];
    }
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            if (success) {
                if (isWarn) {
                    success([[dic objectForKey:@"warn_Id"] longValue]);
                } else {
                    success(-1);
                }
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];

}

#pragma mark - timer
- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)resumeTimer {
    if (self.timer) {
        return;
    }
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        //在这里执行事件
        [self updateTime];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)updateTime {
    [self.goods bk_each:^(BN_ShopGoodModel *obj) {
        
        if (obj.timeleft > 0) {
            obj.timeleft--;
        }
    }];
    BN_ShopGoodModel *obj = [self.goods bk_match:^BOOL(BN_ShopGoodModel * obj) {
        return obj.timeleft > 0;
    }];
//    if (!obj) {
//        [self cancelTimer];
//    }
}

- (void)dealloc
{
    [self cancelTimer];
}

@end
