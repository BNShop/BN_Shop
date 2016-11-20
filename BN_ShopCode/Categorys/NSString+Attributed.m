//
//  NSString+Attributed.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "NSString+Attributed.h"

@implementation NSString (Attributed)
- (NSAttributedString *)setFont:(UIFont *)rangeFont restFont:(UIFont *)restFont range:(NSRange)range {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:restFont}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [text addAttribute:NSFontAttributeName value:rangeFont range:range];
    return text;
}

//中划线
- (NSAttributedString *)strikethroughAttribute{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    return [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    
}

//下划线
- (NSAttributedString *)underlineAttribute{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    return [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    
}
@end
