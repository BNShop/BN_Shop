//
//  BN_ShopHomeADViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeADViewModel.h"

@implementation BN_ADModel

@end

@implementation BN_ShopHomeADViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.adList = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (void)getADArray
{
    NSDictionary *paraDic = @{@"position":@6};
    
    NSString *url = [NSString stringWithFormat:@"%@/homePage/advertisementList", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.adList.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ADModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.adList removeAllObjects];
            
            [temp.adList addObjectsFromArray:returnArray];
            temp.adList.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.adList.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.adList.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}


- (NSArray *)adUrlList {
    NSMutableArray *urls = [NSMutableArray array];
    for (BN_ADModel *adModel in self.adList) {
        [urls addObject:adModel.picUrl];
    }
    return urls;
}

- (NSInteger)adCount {
    return self.adList.count;
}

- (id)adItemWithIndex:(NSInteger)index {
    if (index >= 0 && index < [self.adList count]) {
        NSArray *tmps = self.adList.copy;
        return [tmps objectAtIndex:index];
    }
    return nil;
}

@end
