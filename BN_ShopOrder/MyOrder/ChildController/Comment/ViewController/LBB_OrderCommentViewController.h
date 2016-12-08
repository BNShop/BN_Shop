//
//  LBB_OrderCommentViewController.h
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import "LBB_OrderBaseViewController.h"
#import "LBB_OrderModel.h"

@protocol LBB_OrderCommentDelegate <NSObject>

@optional
- (void)didCommentSuccess:(LBB_OrderModelData*)viewModel;
@end

@interface LBB_OrderCommentViewController : LBB_OrderBaseViewController

@property(nonatomic,strong) LBB_OrderModelData *viewModel;

@property(nonatomic,weak) id<LBB_OrderCommentDelegate> delegate;

- (void)resetDataSourceWithInfo:(NSDictionary*)info IsNeedReload:(BOOL)needReload;

@end
