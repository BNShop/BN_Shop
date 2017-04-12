//
//  BN_MyCollectionViewCell.h
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"
#import "BN_MycollectionModel.h"

@protocol BN_MyCollectionViewCellDelegate;

@interface BN_MyCollectionViewCell : UITableViewCell

@property (nonatomic, weak) id<BN_MyCollectionViewCellDelegate> delegate;

- (void)updateWith:(BOOL)isSelect model:(BN_MycollectionModel *)model;

@end

@protocol BN_MyCollectionViewCellDelegate <NSObject>
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected ;
- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count;
@end
