//
//  BN_ShoppingCartCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"
@protocol BN_ShoppingCartCellDelegate;

@interface BN_ShoppingCartCell : UITableViewCell

@property (nonatomic, weak) id<BN_ShoppingCartCellDelegate> delegate;

- (void)updateWith:(BOOL)isSelect thumbnailUrl:(NSString *)thumbnailUrl title:(NSString *)title num:(NSInteger)num price:(NSString *)price;
@end

@protocol BN_ShoppingCartCellDelegate <NSObject>
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected ;
- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count;
@end
