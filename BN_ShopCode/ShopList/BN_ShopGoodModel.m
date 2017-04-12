//
//  BN_ShopGoodModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodModel.h"
#import "BN_ShopHeader.h"

@implementation BN_ShopGoodModel

- (void)checkeGoodState {
    NSDate *startdate = nil;
    if (self.buying_start_time) {
        startdate = [NSDate dateFromString:self.buying_start_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *endDate = nil;
    if (self.buying_end_time) {
        endDate = [NSDate dateFromString:self.buying_end_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *nowDate = [NSDate date];
    if (startdate && [nowDate isEarlierThanDate:startdate]) {
        self.buying_state = GoodDetaiState_Forward;
    } else if (endDate && [nowDate isEarlierThanDate:endDate]) {
        self.buying_state = GoodDetaiState_Panic;
    } else {
        self.buying_state = GoodDetaiState_End;
    }
}

- (NSDate *)date {
    if (self.buying_state >= 2) {
        return nil;
    }
    if (self.timeleft <= 0) {
        return nil;
    }
    return [NSDate dateWithTimeIntervalSinceNow:self.timeleft];;
}

@end
