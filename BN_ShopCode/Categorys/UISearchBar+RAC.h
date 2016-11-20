//
//  UISearchBar+RAC.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (RAC)
- (RACSignal *)rac_searchBarShouldBeginEditingSignal;
- (RACSignal *)rac_searchBarDidEndEditingSignal;
- (RACSignal *)rac_searchBarSearchButtonClickedSignal;
- (RACSignal *)rac_searchBarCancelButtonClickedSignal;
@end
