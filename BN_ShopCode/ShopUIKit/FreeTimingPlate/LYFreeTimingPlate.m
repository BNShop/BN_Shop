//
//  LYFreeTimingPlate.m
//  日期倒计时
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "LYFreeTimingPlate.h"
#import "BN_ShopHeader.h"

@interface LYFreeTimingPlate ()

@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelMid;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;

@property (weak, nonatomic) IBOutlet UILabel *labelColon0;
@property (weak, nonatomic) IBOutlet UILabel *labelColon1;

@property (weak, nonatomic) IBOutlet UILabel *labelExtend;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;



@end

@implementation LYFreeTimingPlate

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labelMin.font = Font12;
    self.labelMid.font = Font12;
    self.labelMax.font = Font12;
    self.labelExtend.font = Font8;
    self.labelTitle.font = Font10;
    [self updateMinusWhioutBorderPlate:[UIColor clearColor]];
}

- (void)dealloc
{
    [self cancelTimer];
    NSLog(@"定时器释放啦");
}

#pragma mark - timer
- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)resumeTimer {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        //在这里执行事件
        [self updatePlate];
        });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)setDate:(NSDate *)date {
    NSLog(@"开始啦 %@", date);
    if (!date) {
        _date = nil;
        self.labelMax.text = @"00";
        self.labelMid.text = @"00";
        self.labelMin.text = @"00";
        [self cancelTimer];
    } else if (![_date isEqualToDate:date]) {
        _date = date;
        [self resumeTimer];
    }
    
}

- (NSInteger)endTimeWithDate:(NSDate *)date{
    NSTimeInterval sections = [date timeIntervalSinceNow];
    return sections;
}

#pragma mark - ui
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.labelTitle.text = titleStr;
}

- (void)updatePlateWith:(UIColor *)color {
    self.labelMin.q_BorderWidth = 1.0f;
    self.labelMid.q_BorderWidth = 1.0f;
    self.labelMax.q_BorderWidth = 1.0f;
    self.labelMin.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMid.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMax.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMin.textColor = color;
    self.labelMid.textColor = color;
    self.labelMax.textColor = color;
    self.labelColon0.textColor = color;
    self.labelColon1.textColor = color;
    self.labelTitle.textColor = [color colorWithAlphaComponent:0.6f];
    self.labelExtend.textColor = [color colorWithAlphaComponent:0.6f];
}

- (void)updateMinusWhioutBorderPlate:(UIColor *)color {
    self.labelMin.q_BorderWidth = 0.0f;
    self.labelMid.q_BorderWidth = 0.0f;
    self.labelMax.q_BorderWidth = 0.0f;
    self.labelMin.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMid.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMax.q_BorderColor = [color colorWithAlphaComponent:0.2f];
    self.labelMin.textColor = color;
    self.labelMid.textColor = color;
    self.labelMax.textColor = color;
    self.labelColon0.textColor = color;
    self.labelColon1.textColor = color;
    self.labelTitle.textColor = [color colorWithAlphaComponent:0.6f];
    self.labelExtend.textColor = [color colorWithAlphaComponent:0.6f];
}


- (void)updateMinusWhioutBorderPlate {
    [self updateMinusWhioutBorderPlate:ColorRed];;
}

// 年 日/时/分 天 时/分/秒
- (void)updateWith:(NSInteger)extendT maxT:(NSInteger)maxT midT:(NSInteger)midT minT:(NSInteger)minT state:(NSInteger)state {
    self.labelTitle.text = self.titleStr;
    self.labelExtend.hidden = extendT <= 0;
    if (state == 1) {
        self.labelExtend.text = [NSString stringWithFormat:@"%ld年", (long)extendT];
    } else {
        self.labelExtend.text = [NSString stringWithFormat:@"%ld天", (long)extendT];
    }
    NSString *format = @"%.2ld";
    if (maxT > 100) {
        format = @"%ld";
    }
    self.labelMax.text = [NSString stringWithFormat:format, (long)maxT];
    self.labelMid.text = [NSString stringWithFormat:@"%.2ld", (long)midT];
    self.labelMin.text = [NSString stringWithFormat:@"%.2ld", (long)minT];
    
}

- (void)updatePlate {
    NSInteger countdownToLastSeconds = [self endTimeWithDate:self.date];
    NSInteger seconds = countdownToLastSeconds;

    NSInteger yearS = 365 * 24 * 60 * 60;
    NSInteger dayS = 24 * 60 * 60;
    NSInteger hourS = 60  * 60;
    NSInteger minuteS = 60;
    
    NSInteger secondD = seconds % minuteS;
    seconds -= secondD;
    NSInteger minuteD = (seconds % hourS) / minuteS;
    seconds -= minuteD * minuteS;
    NSInteger hourD = (seconds % dayS) / hourS;
    seconds -= hourS * hourD;
    NSInteger dayD = (seconds % yearS) / dayS;
    seconds -= dayS * dayD;
    NSInteger yearD = seconds / yearS;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (yearD > 0) {
            [self updateWith:yearD maxT:dayD midT:hourD minT:minuteD state:1];
        } else {
            [self updateWith:dayD maxT:hourD midT:minuteD minT:secondD state:0];
        }
        
        if (countdownToLastSeconds == 0) {
            [self cancelTimer];
            if ([self.delegate respondsToSelector:@selector(countdownToLastDidEnd:)]) {
                [self.delegate countdownToLastDidEnd:self];
            }
        }
        else if (countdownToLastSeconds == self.countdownToLastSeconds) {
            if ([self.delegate respondsToSelector:@selector(countdownToLastSecondsWillEnd:countdownToLastSeconds:)]) {
                [self.delegate countdownToLastSecondsWillEnd:self countdownToLastSeconds:seconds];
            }
        }
    });
    
}

@end
