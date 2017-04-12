//
//  BN_ShopHomeSouvenirCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BN_ShopHeader.h"

@protocol BN_ShopHomeSouvenirCellDelegate;

@interface BN_ShopHomeSouvenirCell : UITableViewCell

@property (nonatomic, weak) id<BN_ShopHomeSouvenirCellDelegate> delegate;

@property (weak, nonatomic, readonly) IBOutlet UICollectionView *collectionView;

- (void)updateWith:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl dataSource:(id <UICollectionViewDataSource>)dataSource;
@end


@protocol BN_ShopHomeSouvenirCellDelegate <NSObject>

- (void)tableViewWith:(UITableViewCell *)cell collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)clickTitleWith:(UITableViewCell *)cell;
- (void)clickThumbnailWith:(UITableViewCell *)cell;

@end


@interface BN_ShopHomeSouvenirCell (RAC) <BN_ShopHomeSouvenirCellDelegate>
- (RACSignal *)rac_shopHomeSouvenirCellSignal;
- (RACSignal *)rac_shopHomeClickTitleSignal;
- (RACSignal *)rac_shopHomeClickThumbnailSignal;
@end
