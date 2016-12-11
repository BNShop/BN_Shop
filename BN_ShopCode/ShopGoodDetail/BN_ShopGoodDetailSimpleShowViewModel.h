//
//  BN_ShopGoodDetailSimpleShowViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailPicModel : NSObject
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *pic_desc;
@end

@interface BN_ShopGoodDetailSimpleShowViewModel : NSObject
@property (nonatomic, assign) long goodsId;//商品ID
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int cartNum;

@property (nonatomic, strong) NSMutableArray<BN_ShopGoodDetailPicModel*> *photoList;
@property (nonatomic, copy) NSString *shortDescription;

- (void)getPicsData;
- (void)getCartNum:(void(^)(void))success;

- (NSArray *)thumbnailUrlList;
- (NSInteger)thumbnailCount;
- (NSString *)scheduleWith:(NSInteger)index;


//http://xxx.xxx.xxx/mall/goodsDetail（

@end
