//
//  BN_ShopSpecialCommentCell.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopSpecialCommentCell : UITableViewCell

- (void)clickedFollowAction:(void (^)(id sender))handler;
- (void)clickedComentAction:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)iconUrl name:(NSString *)name content:(NSString *)content date:(NSString *)date;
- (void)updateWith:(NSString *)followNum comentNum:(NSString *)comentNum follow:(BOOL)follow;
- (void)updateWith:(NSArray *)imgUrls;

@end
