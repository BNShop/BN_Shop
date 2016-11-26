//
//  BN_ShopGoodDetailNewArrivalsView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@protocol BN_ShopGoodDetailNewArrivalsViewDelegate;

@interface BN_ShopGoodDetailNewArrivalsView : UIView
@property (nonatomic, weak) id<BN_ShopGoodDetailNewArrivalsViewDelegate> delegate;

- (void)updateWith:(NSString *)title subTitle:(NSString *)subTitle;
- (void)updateWith:(NSString *)cellReuseIdentifier registerNib:(UINib *)nib;
- (void)updateWith:(id<UICollectionViewDataSource>)dataSource;

@end

@protocol BN_ShopGoodDetailNewArrivalsViewDelegate <NSObject>

- (void)collectionWith:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BN_ShopGoodDetailNewArrivalsView (RAC)<BN_ShopGoodDetailNewArrivalsViewDelegate>
- (RACSignal *)rac_collectionViewDidSelectItemSignal;
@end
