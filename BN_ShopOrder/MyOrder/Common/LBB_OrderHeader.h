//
//  LBB_OrderHeader.h
//  ST_Travel
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#ifndef LBB_OrderHeader_h
#define LBB_OrderHeader_h

#import "LBB_OrderCommonFun.h"

#define MaxTagNum  6
#define MaxPicture 8

#define TikcetIDKey            @"TicketID"
#define TikcetNameKey          @"TicketName"
#define TikcetImageKey         @"TicketImage"
#define DefaultKey             @"IsDefault"
#define TagContentArrayKey     @"TagContentArrayKey"
#define TicketTagDescKey       @"TagContent"
#define PictureKey             @"Picture"
#define PictureContentArrayKey @"PictureContentArray"
#define StarNumKey             @"StarNum"
#define CommentDescKey         @"CommentDesc"


typedef NS_ENUM(NSInteger,OrderClickType)
{
    eOrderNone = 0 ,//无类型
    eCancelOrder, //取消订单
    ePayOrder,  //立即支付
    eGetOrder,//立即取票
    eCommentOrder,//立即评价
    eShowOrderDetail,  //查看详情
    eDeleteOrder,  //删除订单
    eCheckAales,  //我的订单_查看售后
    eApplyAales  //我的订单_申请售后
};

//1.全部
//2.待付款
//3.待收货
//4.待评价
//5.售后

typedef NS_ENUM(NSInteger,OrderViewType)
{
    eOrderType = 1,
    eOrderType_WaitPay,  //我的订单_待付款
    eOrderType_WaitGetTicket,//我的订单_待收货
    eOrderType_WaitComment,//我的订单_待评价
    eOrderType_AfterAales,  //我的订单_售后
};

#endif /* LBB_OrderHeader_h */
