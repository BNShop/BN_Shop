//
//  BN_MSouvenirTableViewCell.h
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BN_ShopHeader.h"
#import "UITableViewCell+NIB.h"
#import "BN_MySouvenirModel.h"

@protocol BN_MSouvenirTableViewCellDelegate;

@interface BN_MSouvenirTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BN_MSouvenirTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *ADImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (strong, nonatomic) UIButton *collectBtn;
@property (copy, nonatomic) void(^collect)();

- (void)updateWith:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl model:(BN_MySouvenirModel *)model;

@end


@protocol BN_MSouvenirTableViewCellDelegate <NSObject>

- (void)tableViewWith:(UITableViewCell *)cell collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)clickTitleWith:(UITableViewCell *)cell;
- (void)clickThumbnailWith:(UITableViewCell *)cell;

@end
