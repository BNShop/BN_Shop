//
//  Base_BaseViewController+ControlCreate.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController+ControlCreate.h"
#import "UISearchBar+FMAdd.h"
#import "UIImage+TPCategory.h"

@implementation Base_BaseViewController (ControlCreate)

- (UISearchBar *)getSearchBarWithFrame:(CGRect)rect withPlaceholder:(NSString *) placeholeder {
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:rect];
    bar.placeholder = placeholeder;
//    设置搜索图片
    [bar setImage:IMAGE(@"Shop_Search_SearchBarIcon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [bar setImage:IMAGE(@"Shop_Search_SearchBarIcon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected];
    [bar setImage:IMAGE(@"Shop_Search_SearchBarIcon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateHighlighted];
//    设置圆角和边框颜色
    UITextField *searchField = [bar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:ColorWhite];
        searchField.layer.cornerRadius = HEIGHT(bar)/3.0;
        searchField.layer.borderColor = ColorLightGray.CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
//        光标颜色
        searchField.tintColor = ColorLightGray;
    }
//    设置背景图是为了去掉上下黑线
    bar.backgroundImage = [[UIImage alloc] init];
//     设置SearchBar的颜色主题为白色
    bar.barTintColor = ColorWhite;
//    按钮颜色
    bar.tintColor = ColorBlack;
//    设置输入文字颜色跟字体
    [bar fm_setTextFont:Font12];
    [bar fm_setTextColor:ColorLightGray];
    return bar;
}

- (UISearchBar *)getSearchBarWithoutIconWithFrame:(CGRect)rect withPlaceholder:(NSString *) placeholeder {
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:rect];
    bar.placeholder = placeholeder;
    //    设置搜索图片
//    [bar setImage:[UIImage createImageWithColor:ColorWhite] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [bar setImage:IMAGE(@"Shop_Search_SearchBarIcon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected];
    //    设置圆角和边框颜色
    UITextField *searchField = [bar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:ColorWhite];
        searchField.layer.cornerRadius = 4;
        searchField.layer.borderColor = ColorLightGray.CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
//        光标颜色
        searchField.tintColor = ColorLightGray;
    }
    //    设置背景图是为了去掉上下黑线
    bar.backgroundImage = [[UIImage alloc] init];
    //     设置SearchBar的颜色主题为白色
    bar.barTintColor = ColorWhite;
    //    按钮颜色
    bar.tintColor = ColorBlack;
    //    设置输入文字颜色跟字体
    [bar fm_setTextFont:Font12];
    [bar fm_setTextColor:ColorLightGray];
//    设置取消按钮
    [bar fm_setCancelButtonFont:Font12];
    [bar fm_setCancelButtonTitle:TEXT(@"取消")];
    [bar setShowsCancelButton:YES];
    return bar;
}


@end
