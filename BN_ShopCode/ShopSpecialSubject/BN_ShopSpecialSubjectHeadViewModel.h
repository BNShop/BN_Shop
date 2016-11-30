//
//  BN_ShopSpecialSubjectHeadViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

//http://xxx.xxx.xxx/mall/specialDetail（GET）
//specialId Long专题id

@interface BN_ShopSpecialDetailModel : NSObject
@property (assign, nonatomic) long specialId;//专题主键
@property (copy, nonatomic) NSString *name;//专题名称
@property (copy, nonatomic) NSString *content;//专题描述
@property (copy, nonatomic) NSString *cover_img;//专题封面图片
@property (copy, nonatomic) NSString *total_collected;//收藏次数
@property (copy, nonatomic) NSString *total_like;//点赞次数
@property (copy, nonatomic) NSString *total_comment;//评论次数
@property (assign, nonatomic) int is_recommend;//是否是推荐
@property (copy, nonatomic) NSString *remarkd;//备注
@property (copy, nonatomic) NSString *title_display;//显示标题
@property (copy, nonatomic) NSString *vice_title_display;//副标题
@property (copy, nonatomic) NSString *content_display;//显示内容
@end

@interface BN_ShopSpecialSubjectHeadViewModel : BN_BaseDataModel

@property (assign, nonatomic) long specialId;//专题主键
@property (strong, nonatomic) BN_ShopSpecialDetailModel *detailModel;

@property (strong, nonatomic) NSMutableArray *tips;
@property (strong, nonatomic) TableDataSource *dataSource;

- (void)getSpecialDetailData;
@end
