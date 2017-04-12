//
//  BGButton.h
//  QBFlatButtonDemo
//
//  Created by Liya on 16/1/11.
//  Copyright © 2016年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGButton : UIButton
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *hightedColor;

/**
 *  用于修改按钮点击区域
 */
@property (nonatomic, assign) UIEdgeInsets enlargeInset;
@end
