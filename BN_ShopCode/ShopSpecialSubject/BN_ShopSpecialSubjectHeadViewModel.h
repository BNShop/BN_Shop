//
//  BN_ShopSpecialSubjectHeadViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopSpecialSubjectHeadViewModel : NSObject

@property (strong, nonatomic) NSArray *tips;
@property (copy, nonatomic) NSString *comment;
@property (copy, nonatomic) NSString *follow;
@property (copy, nonatomic) NSString *like;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *imgUrl;

@property (strong, nonatomic) TableDataSource *dataSource;
@end
