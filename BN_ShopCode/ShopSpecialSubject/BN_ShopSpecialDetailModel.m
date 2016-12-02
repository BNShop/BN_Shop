//
//  BN_ShopSpecialDetailModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialDetailModel.h"

@implementation BN_ShopSpecialDetailModel
- (void)setTags:(NSArray<BN_ShopspecialTagModel *> *)tags {
    NSMutableArray *array = (NSMutableArray *)[tags map:^id(NSDictionary *element) {
        return [BN_ShopspecialTagModel mj_objectWithKeyValues:element];
    }];
    _tags = array;
}

- (void)setCollectedRecord:(NSArray<BN_ShopSpecialCollectedRecordModel *> *)collectedRecord {
    NSMutableArray *array = (NSMutableArray *)[collectedRecord map:^id(NSDictionary *element) {
        return [BN_ShopSpecialCollectedRecordModel mj_objectWithKeyValues:element];
    }];
    _collectedRecord = array;
}

- (void)setCommentsRecord:(NSArray<BN_ShopGoodSpecialCommentModel *> *)commentsRecord {
    NSMutableArray *array = (NSMutableArray *)[commentsRecord map:^id(NSDictionary *element) {
        return [BN_ShopGoodSpecialCommentModel mj_objectWithKeyValues:element];
    }];
    _commentsRecord = array;
}

@end
