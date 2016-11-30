//
//  BN_ShopSpecialSubjectHeadViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectHeadViewModel.h"

@implementation BN_ShopSpecialDetailModel

@end

@implementation BN_ShopSpecialSubjectHeadViewModel

#pragma mark - 获取专题详情
- (void)getSpecialDetailData {
    NSDictionary *paraDic = @{@"specialId" : @(self.specialId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/specialDetail",BASEURL];
    __weak typeof(self) temp = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            self.detailModel = [BN_ShopSpecialDetailModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}


@end
