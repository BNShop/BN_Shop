//
//  BN_ShopSearchViewController.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@protocol BN_ShopSearchViewControllerDelegate;

@interface BN_ShopSearchViewController : Base_BaseViewController
@property (weak, nonatomic) id<BN_ShopSearchViewControllerDelegate> delegate;
@end

@protocol BN_ShopSearchViewControllerDelegate <NSObject>

- (void)searchTextDidEndEditing:(NSString *)text;
- (void)searchDismiss;

@end

@interface BN_ShopSearchViewController (RAC)
- (RACSignal *)rac_searchTextDidEndEditingSignal;
- (RACSignal *)rac_searchDismissSignal;
@end
