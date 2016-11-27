//
//  BN_ShopHomeFlashSaleViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeFlashSaleViewModel.h"
#import "NSString+Attributed.h"


@implementation BN_ShopFlashSaleModel

@end


@implementation BN_ShopHomeFlashSaleViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flashSaleModel = [[BN_ShopFlashSaleModel alloc] init];
    }
    return self;
}

- (void)getFlashSaleData
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/indexLimitTimeGoods",BASEURL];
    __weak typeof(self) temp = self;
    self.flashSaleModel.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            [temp.flashSaleModel mj_setKeyValues:[dic objectForKey:@"result"]];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        
        temp.flashSaleModel.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        temp.flashSaleModel.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

- (NSAttributedString *)priceAttri {
    return [[NSString stringWithFormat:@"¥%@", self.flashSaleModel.real_price] setFont:Font12 restFont:Font15 range:NSMakeRange(0, 1)];
}

- (NSDate *)date {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:self.flashSaleModel.timeleft];
    return date;
}

- (NSString *)timeTitle {
    if (self.flashSaleModel.buying_state == 0) {
        return nil;
    } else if (self.flashSaleModel.buying_state == 1) {
        return TEXT(@"距离结束时间");
    } else {
        return TEXT(@"已结束");
    }
}

- (UIColor *)timeColor {
    if (self.flashSaleModel.buying_state == 0) {
        return ColorBtnYellow;
    } else if (self.flashSaleModel.buying_state == 1) {
        return ColorRed;
    } else {
        return ColorLightGray;
    }
}

@end
