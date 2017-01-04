//
//  BN_MyCollectionToolBar.h
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_MyCollectionToolBar : UIView

@property (nonatomic, copy) void(^selectAll)(BOOL isSelect);
@property (nonatomic, copy) void(^deleteClick)();
@property (nonatomic, assign, getter=isEdit) BOOL edit;

@end
