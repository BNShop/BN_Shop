//
//  BN_ShopSpecialSubjectHeadView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopSpecialSubjectHeadView : UIView
- (void)updateWith:(NSString *)imgUrl comment:(NSString *)comment follow:(NSString *)follow like:(NSString *)like content:(NSString *)content;
- (void)collectionViewRegisterNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (void)updateWith:(id<UICollectionViewDataSource>)dataSource;
- (CGFloat)getViewHeight;
@end
