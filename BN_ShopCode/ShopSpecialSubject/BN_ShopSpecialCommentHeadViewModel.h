//
//  BN_ShopSpecialCommentHeadViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BN_ShopSpecialCommentHeadViewModel : NSObject
@property (assign, nonatomic) long specialId;//专题主键
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSArray *imgUrls;
//@property (nonatomic, assign) BOOL isFollow;

- (NSString *)numStr;

@end
