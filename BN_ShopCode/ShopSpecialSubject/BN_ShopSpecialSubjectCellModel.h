//
//  BN_ShopSpecialSubjectCellModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/23.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopSpecialSubjectCellModel : NSObject
@property (copy, nonatomic) NSString *No;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *contentHtml;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *subImgUrl;
@property (copy, nonatomic) NSString *follow;
@property (copy, nonatomic) NSString *price;

- (NSAttributedString *)contentAttributed;
- (NSAttributedString *)priceAttributed;
- (NSString *)followStr;

@end
