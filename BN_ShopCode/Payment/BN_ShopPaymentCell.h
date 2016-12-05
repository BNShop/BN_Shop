//
//  BN_ShopPaymentCell.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopPaymentCell : UITableViewCell

- (void)updateWith:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle;
@end
