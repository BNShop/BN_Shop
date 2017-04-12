//
//  BN_MycollectionModel.m
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_MycollectionModel.h"
#import "BN_ShopHeader.h"

@implementation BN_MycollectionModel
{
    NSTimer *_timer;
    NSInteger _seconds;
}

- (NSString *)remainingTimeMethodAction {
    NSDate *nowData = [NSDate date];
    NSDate *endData=[NSDate dateWithTimeIntervalSince1970:self.end_time];
    

    
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
    NSUInteger unitFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:nowData toDate: endData options:0];
    NSInteger Hour = [cps hour];
    NSInteger Min = [cps minute];
    NSInteger Sec = [cps second];
    NSInteger Day = [cps day];
    NSInteger Mon = [cps month];
    NSInteger Year = [cps year];
    NSLog( @" From Now to %@, diff: Years: %d Months: %d, Days; %d, Hours: %d, Mins:%d, sec:%d",
          [nowData description], Year, Mon, Day, Hour, Min,Sec );
    NSString *countdown = [NSString stringWithFormat:@"还剩: %zi天 %zi小时 %zi分钟 %zi秒 ", Day,Hour, Min, Sec];
    if (self.buying_state == 0 ) {
        return [NSString stringWithFormat:@"距离结束时间：%zi:%zi:%zi",Hour, Min, Sec];
    }else if (self.buying_state == 1) {
        return [NSString stringWithFormat:@"距离结束时间：%zi:%zi:%zi",Hour, Min, Sec];
    }else {
     return [NSString stringWithFormat:@"距离结束时间：%.2zi:%.2zi:%.2zi",00, 00, 00];
    }
}

- (void)setTimeleft:(int)timeleft
{
    if (_timer != nil) {
        _timer = nil;
    }
    _timer =  [NSTimer scheduledTimerWithTimeInterval:self.timeleft target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [_timer fire];
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

-(void)timeFireMethod {
    _seconds --;
    if(_seconds<=0){
        [_timer invalidate];
        self.buying_state = 2;
        self.timerStr = [NSString stringWithFormat:@"距离结束时间：%.2zi:%.2zi:%.2zi",00, 00, 00];
    }else {
        int Sec = _seconds % 60;
        int Min = (_seconds / 60) % 60;
        int Hour = _seconds / 3600;
        if (self.buying_state == 0 ) {
            self.timerStr = [NSString stringWithFormat:@"距离结束时间：%.2zi:%.2zi:%.2zi",Hour, Min, Sec];
        }else if (self.buying_state == 1) {
            self.timerStr = [NSString stringWithFormat:@"距离结束时间：%.2zi:%.2zi:%.2zi",Hour, Min, Sec];
        }else {
            self.timerStr = [NSString stringWithFormat:@"距离结束时间：%.2zi:%.2zi:%.2zi",00, 00, 00];
        }
    }
}


@end
