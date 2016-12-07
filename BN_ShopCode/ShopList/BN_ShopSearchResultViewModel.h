//
//  BN_ShopSearchResultViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopSearchResultViewModel : NSObject <UICollectionViewDelegate>

@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, strong) TableDataSource *resultDataSource;
@property (nonatomic, copy) void(^collectionSelectBlock)(id obj);
@property (nonatomic, copy) void(^collectionScrollBlock)();

- (void)getSearchResultDataRes:(BOOL)clear keyword:(NSString *)keyword;
@end
