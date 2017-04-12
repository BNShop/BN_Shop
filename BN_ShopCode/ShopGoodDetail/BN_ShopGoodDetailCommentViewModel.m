//
//  BN_ShopGoodDetailCommentViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailCommentViewModel.h"
#import "NSArray+BlocksKit.h"


@implementation BN_ShopGoodDetailCommentViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] initFromNet];
        self.dataSource = [[TableDataSource alloc] initWithItems:self.items cellIdentifier:nil configureCellBlock:nil];
    }
    return self;
}

- (NSString *)avgort {
    return [NSString stringWithFormat:@"%d.0", self.avg_score];
}


#pragma mark - 获取评论列表
- (void)getCommentsClearData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.items.count/10.0);
    NSDictionary *paraDic = @{@"objId" : @(self.objId),
                              @"type" : @(self.type),
                              @"curPage" : @(curPage),
                              @"pageNum" : @10};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/commentLists", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.items.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodCommentsModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear) {
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
