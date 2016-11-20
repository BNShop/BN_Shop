//
//  BN_ShopGoodDetailSimpleShowViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodDetailSimpleShowViewModel : NSObject

@property (nonatomic, strong) NSArray *photoList;
@property (nonatomic, copy) NSString *shortDescription;

- (NSArray *)thumbnailUrlList;
- (NSInteger)thumbnailCount;
- (NSString *)scheduleWith:(NSInteger)index;

@end
