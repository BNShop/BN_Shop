//
//  BN_ShopSpecialSubjectCellModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/23.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectCellModel.h"
#import "NSString+Attributed.h"

@implementation BN_ShopSpecialSubjectCellModel

- (NSAttributedString *)contentAttributed {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.contentHtml dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

- (NSAttributedString *)priceAttributed {
    NSString *str = [NSString stringWithFormat:@"¥%@", self.price];
    return [str setFont:Font10 restFont:Font16 range:NSMakeRange(0, 1)];
}

- (NSString *)followStr {
    return [NSString stringWithFormat:@"%@%@", self.follow, TEXT(@"个人喜欢")];
}

@end
