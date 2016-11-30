//
//  BN_ShopHomeSouvenirCellModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeSouvenirCellModel.h"



@implementation BN_ShopHomeSouvenirCellModel


- (NSString *)thumbnailUrl {
    return self.souvenirModel.pic_horizontal_url;
}

- (NSString *)title {
    return self.souvenirModel.name;
}


@end
