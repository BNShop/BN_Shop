//
//  BN_ShopSpecialSubjectCell.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopSpecialSubjectCell : UITableViewCell

- (void)clickedAction:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)num title:(NSString *)title subTitle:(NSString *)subTitle content:(NSAttributedString *)conten follow:(NSString *)follow price:(NSAttributedString *)price;
- (void)updateWith:(NSString *)imgUrl subImgUrl:(NSString *)subImgUrl completed:(void(^)(id cell))block;
@end
