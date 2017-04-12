//
//  BN_ShopGoodDetailCommentsCell.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopGoodDetailCommentsCell : UITableViewCell

- (void)updateWith:(NSString *)name dateStr:(NSString *)dateStr content:(NSString *)conten goodStr:(NSString *)goodStr icon:(NSString *)icon;
- (void)updateWith:(NSArray *)imgUrls;
@end
