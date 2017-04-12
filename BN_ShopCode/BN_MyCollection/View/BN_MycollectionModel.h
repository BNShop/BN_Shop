//
//  BN_MycollectionModel.h
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_MycollectionModel : NSObject

@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *pic_url;//商品图片地址
@property (nonatomic, assign) long goodsId;//商品id
@property (nonatomic, copy) NSString *front_price;//商品显示价格
@property (nonatomic, copy) NSString *real_price;//商品真实价格
@property (nonatomic, assign) int total_comment;//评价数
@property (nonatomic, assign) int buying_state;//限时状态0:未开始1:抢购中2:已结束
@property (nonatomic, assign) int start_time;//距开始时间
@property (nonatomic, assign) int end_time;//距结束时间
@property (nonatomic, assign) int cur_state;//上架状态1：上架0：下架
@property (nonatomic, assign) long collect_id;//收藏id
@property (nonatomic, assign) long warn_id;//有值：已设置提醒，-1：没设置提醒
@property (nonatomic, assign) int avail_buying_num;//可买数量
@property (nonatomic, assign) int out_buying_num;//已卖数量
@property (nonatomic, assign) int timeleft;//剩余时间
@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic, getter=isEdit) BOOL edit;
@property (nonatomic, strong) NSString *timerStr; // 转换时间
- (NSDate *)date;//抢购时间点
- (NSString*)remainingTimeMethodAction;

@end
