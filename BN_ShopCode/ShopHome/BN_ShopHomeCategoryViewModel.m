//
//  BN_ShopHomeCategoryViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeCategoryViewModel.h"

@implementation BN_ShopHomeCategoryViewModel


- (instancetype)init {
    if (self = [super init]) {
        self.categorys = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (id)categoryWithIndex:(NSInteger)index {
    if (index >= [self.categorys count] || index < 0)
        return nil;
    NSArray *tmpItems = [self.categorys copy];
    return tmpItems[index];
}

- (NSArray *)categoryTitles {
    NSMutableArray *titles = [NSMutableArray array];
    for (BN_ShopCategoryModel *obj in self.categorys) {
        [titles addObject:obj.name];
    }
    return titles.copy;
}

- (void)getCategoryArray
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/navList", BASEURL];
    __weak typeof(self) temp = self;
    self.categorys.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopCategoryModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.categorys removeAllObjects];
            
            [temp.categorys addObjectsFromArray:returnArray];
            temp.categorys.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.categorys.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.categorys.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

@end
