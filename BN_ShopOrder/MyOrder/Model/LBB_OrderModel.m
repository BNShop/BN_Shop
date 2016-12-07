//
//  LBB_OrderModel.m
//  ST_Travel
//
//  Created by 美少男 on 16/11/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderModel.h"
//#import "Mine_Common.h"

@implementation LBB_OrderModelDetail

@end


@implementation LBB_OrderModelData

- (id)init
{
    self = [super init];
    if (self) {
         
    }
    return self;
}

/**
 *3.6.4 申请售后
 */
//saleafterDesc	String	描述
//saleafterType	Int	售后类型
//saleafterPics	List	{saleafterPics:
//    [‘111.jpg’,’2222.jpg’]
//}
//备注：售后图

- (void)addSaleafter:(NSString*)saleafterDesc saleafterType:(int)saleafterType saleafterPics:(NSArray*)saleafterPics
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/addSaleafter?orderId=%@",BASEURL,self.order_id];
    
    NSDictionary *parames = nil;
    
    __weak typeof(self) weakSelf = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            weakSelf.order_state = 10;//已取消
            weakSelf.loadSupport.loadEvent = codeNumber.intValue;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.loadSupport.loadFailEvent = NetLoadFailedEvent;
    }];
    
}
/**
 *3.6.7 取消订单
 */
- (void)cancelOrder
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/cancelOrder?orderId=%@",BASEURL,self.order_id];
    
    NSDictionary *parames = nil;
    
    __weak typeof(self) weakSelf = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            weakSelf.order_state = 10;//已取消
            weakSelf.loadSupport.loadEvent = codeNumber.intValue;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.loadSupport.loadFailEvent = NetLoadFailedEvent;
    }];
    
}

/**
 *3.6.8 删除订单
 */
- (void)deleteOrder
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/deleteOrder?orderId=%@",BASEURL,self.order_id];
    NSDictionary *parames = nil;
    
    __weak typeof(self) weakSelf = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            weakSelf.loadSupport.loadEvent = codeNumber.intValue;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.loadSupport.loadFailEvent = NetLoadFailedEvent;
    }];
}

/**
 *3.6.9 确认收货
 */
- (void)confirmReceipt
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/confirmReceipt?orderId=%@",BASEURL,self.order_id];
    NSDictionary *parames = nil;
    
    __weak typeof(self) weakSelf = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            weakSelf.order_state = 3;//已完成
            weakSelf.loadSupport.loadEvent = codeNumber.intValue;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.loadSupport.loadFailEvent = NetLoadFailedEvent;
    }];
}

/**
 *3.6.10 评价
 @comments @{goodsId:123 ,mind:评论, score:1 pics:图片（多张逗号隔开）}
 */
- (void)addComment:(NSDictionary*)comments
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/addComment",BASEURL];
    NSDictionary *parames = @{
                              @"orderId":self.order_id,
                              @"comments" : @{@"测试字段":@"测试字段"}
                              };
    
    __weak typeof(self) weakSelf = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            weakSelf.order_state = 3;//已完成
            weakSelf.loadSupport.loadEvent = codeNumber.intValue;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.loadSupport.loadFailEvent = NetLoadFailedEvent;
    }];
}

@end


@implementation LBB_OrderViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (void)getDataArray:(int)orderSearchType IsClear:(BOOL)isClear
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/orderList",BASEURL];
    
    int curPage = isClear == YES ? 0 : round(self.dataArray.count/10.0);
    
    NSDictionary *parames = @{
                              @"curPage":[NSNumber numberWithInt:curPage],
                              @"pageNum":[NSNumber numberWithInt:10],
                              @"orderSearchType":@(orderSearchType),
                              @"orderType":@(2)
                              };
    
    __weak typeof(self) weakSelf = self;
    self.dataArray.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:parames success:^(NSURLSessionDataTask *operation, id responseObject) { 
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpDict in array) {
                LBB_OrderModelData *modelData = [[LBB_OrderModelData alloc] init];
                modelData.goods_num = [[tmpDict objectForKey:@"goods_num"] intValue];
                modelData.integral_amount = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"integral_amount"]];
                modelData.goods_amount = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"goods_amount"]];
                modelData.freight_amount = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"freight_amount"]];
                modelData.pay_type = [[tmpDict objectForKey:@"pay_type"] intValue];
                modelData.order_id = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"order_id"]];
                modelData.order_state = [[tmpDict objectForKey:@"order_state"] intValue];
                modelData.order_no = [tmpDict objectForKey:@"order_no"];
                modelData.comments_state  = [[tmpDict objectForKey:@"comments_state"] intValue];
                modelData.order_state_name = [tmpDict objectForKey:@"order_state_name"];
                modelData.comment_state_name = [tmpDict objectForKey:@"comment_state_name"];
                modelData.saleafter_state_name = [tmpDict objectForKey:@"saleafter_state_name"];
                modelData.saleafter_state = [[tmpDict objectForKey:@"saleafter_state"] intValue];
                NSArray *goodsList = [tmpDict objectForKey:@"goodsList"];
                NSMutableArray *goodArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *detailDict in goodsList) {
                    LBB_OrderModelDetail *detail = [[LBB_OrderModelDetail alloc] init];
                    detail.front_price = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"front_price"]];
                    detail.goods_id = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"goods_id"]];
                    detail.goods_name = [detailDict objectForKey:@"goods_name"];
                    detail.goods_num = [[detailDict objectForKey:@"goods_num"] intValue];
                    detail.order_id = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"order_id"]];
                    detail.order_no = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"order_no"]];
                    detail.order_state_name = [detailDict objectForKey:@"order_state_name"];
                    detail.pic_url = [detailDict objectForKey:@"pic_url"];
                    detail.real_price = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"real_price"]];
                    detail.standard = [detailDict objectForKey:@"standard"];
                    [goodArray addObject:detail];
                }
                modelData.goodsList = goodArray;
                [resultArray addObject:modelData];
            }
//            NSArray *returnArray = [LBB_OrderModelData mj_objectArrayWithKeyValuesArray:array];
            if (isClear) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:resultArray];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.dataArray.networkTotal = [dic objectForKey:@"total"];
        weakSelf.dataArray.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.dataArray.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

@end



@implementation LBB_SaleafterTypeModel


@end


@implementation LBB_SaleafterTypeViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

/**
 *3.6.6 售后原因列表
 */
- (void)getSaleafterType
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/dictList?classes=saleafter_type",BASEURL];

    __weak typeof(self) weakSelf = self;
    self.dataArray.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [LBB_SaleafterTypeModel mj_objectArrayWithKeyValuesArray:array];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:returnArray];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            NSLog(@"失败  %@",errorStr);
        }
        weakSelf.dataArray.networkTotal = [dic objectForKey:@"total"];
        weakSelf.dataArray.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        weakSelf.dataArray.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

@end
