//
//  BN_ShopOrdersItemCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopOrdersItemCell : UITableViewCell
- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title num:(NSInteger)num price:(NSString *)price specification:(NSString *)specification;
@end
