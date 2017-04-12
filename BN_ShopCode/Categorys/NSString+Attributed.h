//
//  NSString+Attributed.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Attributed)
- (NSAttributedString *)setFont:(UIFont *)rangeFont restFont:(UIFont *)restFont range:(NSRange)range;
- (NSAttributedString *)setColor:(UIColor *)rangeColor restColor:(UIColor *)restColor range:(NSRange)range;
- (NSAttributedString *)strikethroughAttribute;
- (NSAttributedString *)underlineAttribute;
@end
