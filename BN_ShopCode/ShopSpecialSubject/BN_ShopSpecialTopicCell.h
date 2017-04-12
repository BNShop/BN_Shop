//
//  BN_ShopSpecialTopicCell.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopSpecialTopicCell : UITableViewCell
- (void)updateWith:(NSString *)imgUrl title:(NSString *)title subTitle:(NSString *)subTitle tip:(NSString *)tip;
@end
