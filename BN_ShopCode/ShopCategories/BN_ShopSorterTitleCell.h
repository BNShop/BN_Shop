//
//  BN_ShopSorterTitleCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopSorterTitleCell : UITableViewCell
- (void)updateWith:(NSString *)title selected:(BOOL)selected;
@end
