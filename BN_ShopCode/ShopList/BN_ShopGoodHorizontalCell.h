//
//  BN_ShopGoodHorizontalCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopGoodHorizontalCell : UICollectionViewCell
- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title front:(NSString *)front real:(NSAttributedString *)real additional:(NSString *)additional;
@end
