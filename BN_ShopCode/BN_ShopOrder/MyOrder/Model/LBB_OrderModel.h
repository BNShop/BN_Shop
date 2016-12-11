//
//  LBB_OrderModel.h
//  ST_Travel
//
//  Created by 美少男 on 16/11/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBB_OrderModelDetail :BN_BaseDataModel

@property(nonatomic,copy) NSString*  front_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,assign) int goods_num;
@property(nonatomic,copy) NSString*  order_id;
@property(nonatomic,copy) NSString* order_no;
@property(nonatomic,copy) NSString *order_state_name;//订单状态（如待支付）
@property(nonatomic,copy) NSString *pic_url;
@property(nonatomic,copy) NSString* real_price;
@property(nonatomic,copy) NSString *standard; //商品规格

@end


@interface LBB_OrderModelData : BN_BaseDataModel

@property(nonatomic,assign) int goods_num;
@property(nonatomic,copy) NSString*  integral_amount;
@property(nonatomic,copy) NSString*   goods_amount;//商品总价
@property(nonatomic,copy) NSString*   freight_amount;//运费
@property(nonatomic,assign) int      pay_type;//1 微信支付 支付2 支付宝支付3 平安银行支付
@property(nonatomic,copy) NSString*     order_id;
@property(nonatomic,assign) int      order_state;//订单状态 0待付款1已付款2待收货3已完成10已取消
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,assign) int  comments_state;// 0 未评价1已评价
@property(nonatomic,copy) NSString *order_state_name;//@"待付款"
@property(nonatomic,copy) NSString *comment_state_name;//@"未评价"
@property(nonatomic,copy) NSString *saleafter_state_name;//@"未发起售后"
@property(nonatomic,assign)int saleafter_state;//售后状态0 未发起售后1申请中2 处理中3已完成
@property (nonatomic,copy) NSMutableArray<LBB_OrderModelDetail *> *goodsList; //订单物品数组

/**
 *3.6.4 申请售后
 */
//saleafterDesc	String	描述
//saleafterType	Int	售后类型
//saleafterPics	List	{saleafterPics:
//    [‘111.jpg’,’2222.jpg’]
//}
//备注：售后图

- (void)addSaleafter:(NSString*)saleafterDesc saleafterType:(int)saleafterType saleafterPics:(NSArray*)saleafterPics;

/**
 *3.6.7 取消订单
 */
- (void)cancelOrder;

/**
 *3.6.8 删除订单
 */
- (void)deleteOrder;

/**
 *3.6.9 确认收货
 */
- (void)confirmReceipt;

/**
 *3.6.10 评价
 @comments @{goodsId:123 ,mind:评论, score:1 pics:图片（多张逗号隔开）}
 */
- (void)addComment:(NSArray*)comments;


@end

@interface LBB_OrderViewModel : BN_BaseDataModel

@property(nonatomic,strong) NSMutableArray<LBB_OrderModelData*>* dataArray;

/**
 *3.6.1 订单列表
 *@parames orderSearchType 订单状态 1.全部2.待付款3.待收货4.待评价5.售后
 */
- (void)getDataArray:(int)orderSearchType IsClear:(BOOL)isClear;

@end



