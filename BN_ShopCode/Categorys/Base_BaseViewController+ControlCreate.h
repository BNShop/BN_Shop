//
//  Base_BaseViewController+ControlCreate.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@interface Base_BaseViewController (ControlCreate)
- (UISearchBar *)getSearchBarWithFrame:(CGRect)rect withPlaceholder:(NSString *) placeholeder;
- (UISearchBar *)getSearchBarWithoutIconWithFrame:(CGRect)rect withPlaceholder:(NSString *) placeholeder;
@end
