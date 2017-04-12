//
//  LBB_OrderCommonFun.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/7.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderCommonFun.h"
#import "BN_ShopHeader.h"

@implementation LBB_OrderCommonFun

CGSize OrderSizeOfString(NSString *str, CGSize constranedSize, UIFont *font)
{
    if (constranedSize.width && constranedSize.height) {
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: font,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGSize size = [str boundingRectWithSize:constranedSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes context:nil].size;
        
        size.width = ceil(size.width);
        size.height = ceil(size.height);
        
        return size;
    } else {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: font,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGSize size = [str sizeWithAttributes:attributes];
        size.width = ceil(size.width);
        size.height = ceil(size.height);
        
        return size;
    }
}

@end
