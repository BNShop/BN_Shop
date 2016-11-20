//
//  BN_ShopGoodDetailSimpleShowView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopGoodDetailSimpleShowView : UIView

- (RACSignal *)rac_thumbnailDidScrollToIndexSignal;
- (RACSignal *)rac_thumbnailDidSelectItemAtIndexSignal;

- (void)updateWith:(NSString *)title schedule:(NSString *)schedule;
- (void)updateThumbnailWith:(NSArray *)thumbnailUrls;
@end
