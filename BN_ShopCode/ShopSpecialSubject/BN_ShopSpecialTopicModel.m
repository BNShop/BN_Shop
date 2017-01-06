//
//  BN_ShopSpecialTopicModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialTopicModel.h"

@implementation BN_ShopSpecialTopicModel
- (void)setTags:(NSArray<BN_ShopspecialTagModel *> *)tags {
    _tags = [BN_ShopspecialTagModel mj_objectArrayWithKeyValuesArray:tags];
    self.tagName = _tags.firstObject.tagName;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"special_id":@"specialId"};
}
@end
