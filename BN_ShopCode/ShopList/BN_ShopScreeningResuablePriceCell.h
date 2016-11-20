//
//  BN_ShopScreeningResuablePriceCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopScreeningResuablePriceCell : UICollectionViewCell
- (void)setPriceChangedBlock:(void (^)(NSString *text, NSInteger indexPath)) block;

- (void)updateWith:(NSString *)minPrice maxPrice:(NSString *)maxPrice;
@end
