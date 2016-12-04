//
//  BN_ShopGoodSpecialModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodSpecialModel.h"
#import "NSString+Attributed.h"

@implementation BN_ShopGoodSpecialModel

- (NSAttributedString *)contentAttributed {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.content_display dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

- (NSAttributedString *)priceAttributed {
    NSString *str = [NSString stringWithFormat:@"¥%@", self.real_price];
    return [str setFont:Font10 restFont:Font16 range:NSMakeRange(0, 1)];
}

- (NSString *)followStr {
    return [NSString stringWithFormat:@"%d%@", self.total_like, TEXT(@"个人喜欢")];
}

@end
