//
//  BN_GoodStateHeader.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#ifndef BN_GoodStateHeader_h
#define BN_GoodStateHeader_h
typedef NS_ENUM(NSUInteger, GoodDetaiStateType) {
    GoodDetaiState_Forward,//未开始
    GoodDetaiState_Panic,//抢购中
    GoodDetaiState_End,//已结束
    GoodDetaiState_Normal,//普通不参与抢购
    
};

#endif /* BN_GoodStateHeader_h */
