//
//  BN_ShopHomeFlashSaleViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeFlashSaleViewModel.h"
#import "NSString+Attributed.h"
#import "BN_GoodStateHeader.h"


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
            [temp checkeBuyingState];
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

- (void)checkeBuyingState {
    NSDate *startdate = nil;
    if (self.flashSaleModel.buying_start_time) {
        startdate = [NSDate dateFromString:self.flashSaleModel.buying_start_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *endDate = nil;
    if (self.flashSaleModel.buying_end_time) {
        endDate = [NSDate dateFromString:self.flashSaleModel.buying_end_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *nowDate = [NSDate date];
    if ((startdate && [nowDate isEarlierThanDate:startdate])
        || (self.flashSaleModel.timeleft > 0 && self.flashSaleModel.buying_state == GoodDetaiState_Forward)) {
        self.flashSaleModel.buying_state = GoodDetaiState_Forward;
    } else if ((endDate && [nowDate isEarlierThanDate:endDate])
               || (self.flashSaleModel.timeleft > 0 && self.flashSaleModel.buying_state == GoodDetaiState_Panic)) {
        self.flashSaleModel.buying_state = GoodDetaiState_Panic;
    } else {
        self.flashSaleModel.buying_state = GoodDetaiState_End;
    }
}

- (NSAttributedString *)priceAttri {
    return [[NSString stringWithFormat:@"¥%@", self.flashSaleModel.real_price] setFont:Font12 restFont:Font15 range:NSMakeRange(0, 1)];
}

- (NSDate *)date {
    
    if (self.flashSaleModel.timeleft > 0) {
        return [NSDate dateWithTimeIntervalSinceNow:self.flashSaleModel.timeleft];;
    }
    
    if (self.flashSaleModel.buying_state == GoodDetaiState_Forward) {
        return [NSDate dateFromString:self.flashSaleModel.buying_start_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (self.flashSaleModel.buying_state == GoodDetaiState_Panic) {
        return [NSDate dateFromString:self.flashSaleModel.buying_end_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    
    
    return nil;
}

- (NSString *)timeTitle {
    if (self.flashSaleModel.buying_state == GoodDetaiState_Forward) {
        return TEXT(@"");
    } else if (self.flashSaleModel.buying_state == GoodDetaiState_Panic) {
        return TEXT(@"距离结束时间");
    } else {
        return TEXT(@"抢购已结束");
    }
}

- (UIColor *)timeColor {
    if (self.flashSaleModel.buying_state == GoodDetaiState_Forward) {
        return ColorBtnYellow;
    } else if (self.flashSaleModel.buying_state == GoodDetaiState_Panic) {
        return ColorRed;
    } else {
        return ColorLightGray;
    }
}

@end
