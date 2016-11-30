//
//  BN_ShopGoodDetailSimpleShowViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailSimpleShowViewModel.h"

@implementation BN_ShopGoodDetailPicModel

@end

@implementation BN_ShopGoodDetailSimpleShowViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photoList = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (NSArray *)thumbnailUrlList {
    NSMutableArray *tmpurls = [NSMutableArray array];
    for (BN_ShopGoodDetailPicModel *model in self.photoList) {
        [tmpurls addObject:model.image_url];
    }
    return tmpurls;
}

- (NSInteger)thumbnailCount {
    return [self.photoList count];
}

- (NSString *)scheduleWith:(NSInteger)index {
    if (self.thumbnailCount == 0) {
        return @"0/0";
    } else if (index == 0) {
        index = 1;
    }
    return [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)[self thumbnailCount]];
}

#pragma mark - 数据获取
- (void)getPicsData {
    NSDictionary *paraDic = @{@"goodsId" : @(self.goodsId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsPics",BASEURL];
    __weak typeof(self) temp = self;
    self.photoList.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodDetailPicModel mj_objectArrayWithKeyValuesArray:array];
            [temp.photoList addObjectsFromArray:returnArray];
            temp.photoList.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.photoList.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.photoList.loadSupport.loadEvent = NetLoadFailedEvent;
    }];

}

@end
