//
//  BN_ShopHomeADViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopHomeADViewModel : NSObject
@property (nonatomic, strong) NSArray *adList;

- (NSArray *)adUrlList;
- (NSInteger)adCount;
- (id)adItemWithIndex:(NSInteger)index;

@end
