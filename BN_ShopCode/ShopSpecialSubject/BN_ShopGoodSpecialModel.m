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
    
    NSMutableArray *strArray = [[NSMutableArray alloc]initWithArray:[self.content_display componentsSeparatedByString:@"\""]];
    [strArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj rangeOfString:@"width="].location != NSNotFound) {
            NSString *strWidth = strArray[idx + 1];
            NSString *strHeight = strArray[idx + 3];
            strHeight = [NSString stringWithFormat:@"%d",(int)((DeviceWidth*strHeight.floatValue*1.0)/strWidth.floatValue)];
            strWidth = [NSString stringWithFormat:@"%d",(int)DeviceWidth];
            strArray[idx + 1] = strWidth;
            strArray[idx + 3] = strHeight;
        }
    }];
    self.content_display = [strArray componentsJoinedByString:@"\""];
    
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
