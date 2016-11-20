//
//  BN_ShopGoodDetailSimpleShowView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailSimpleShowView.h"
#import "SDCycleScrollView.h"

@interface BN_ShopGoodDetailSimpleShowView () <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *thumbnailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;


@end

@implementation BN_ShopGoodDetailSimpleShowView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumbnailScrollView.autoScroll = NO;
    self.thumbnailScrollView.showPageControl = NO;
    
    self.titleLabel.textColor = ColorLightGray;
    self.titleLabel.font = Font12;
    
    self.scheduleLabel.textColor = ColorBlack;
    self.scheduleLabel.font = Font8;
    self.scheduleLabel.q_BorderColor = ColorLine;
    self.scheduleLabel.q_BorderWidth = 1.0f;
    
    [self sizeToFit];
    
}

- (RACSignal *)rac_thumbnailDidScrollToIndexSignal
{
    self.thumbnailScrollView.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(cycleScrollView:didScrollToIndex:) fromProtocol:@protocol(SDCycleScrollViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.last;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_thumbnailDidSelectItemAtIndexSignal
{
    self.thumbnailScrollView.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(cycleScrollView:didSelectItemAtIndex:) fromProtocol:@protocol(SDCycleScrollViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.last;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (void)updateWith:(NSString *)title schedule:(NSString *)schedule {
    self.titleLabel.text = title;
    self.scheduleLabel.text = schedule;
    self.thumbnailScrollView.autoScroll = NO;
    self.thumbnailScrollView.showPageControl = NO;
}

- (void)updateThumbnailWith:(NSArray *)thumbnailUrls {
    self.thumbnailScrollView.imageURLStringsGroup = thumbnailUrls.copy;
    self.thumbnailScrollView.autoScroll = NO;
    self.thumbnailScrollView.showPageControl = NO;
}

@end
