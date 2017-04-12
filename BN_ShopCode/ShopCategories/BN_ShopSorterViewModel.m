//
//  BN_ShopSorterViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSorterViewModel.h"
#import "BN_ShopHeader.h"

@implementation BN_ShopSorterViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.curCategoryId = -1;
        self.categories = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}


- (TableDataSource *)getTitleDataSourceWith:(NSArray *)titles
                             cellIdentifier:(NSString *)aCellIdentifier
                         configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
    if (!_titleDataSource) {
        _titleDataSource = [[TableDataSource alloc] initWithItems:titles cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    } else {
        [_titleDataSource resetItems:titles cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    }
    return _titleDataSource;
}


- (TableDataSource *)getSecondDataSourceWith:(NSArray *)items
                              cellIdentifier:(NSString *)aCellIdentifier
                          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
    if (!_secondCategoryDataSource) {
        _secondCategoryDataSource = [[TableDataSource alloc] initWithItems:items cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    } else {
        [_secondCategoryDataSource resetItems:items cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    }
    return _secondCategoryDataSource;
}

- (TableDataSource *)getSecondDataSourceWith:(NSArray *)items {
    [_secondCategoryDataSource resetItems:items];
    return _secondCategoryDataSource;
}



#pragma mark - 获取titles的数据
- (void)getCategories
{
    NSString *url = [NSString stringWithFormat:@"%@/mall/categoryList", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.categories.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"%@", operation.currentRequest);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopCategoryModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.categories removeAllObjects];
            
            [temp.categories addObjectsFromArray:returnArray];
            temp.categories.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.categories.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.categories.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}



#pragma mark - 获取对应的second的数据
- (void)getSecondCategories:(BN_ShopCategoryModel *)categoryModel
{
    NSDictionary *paraDic = @{
                              @"parentCategoryId":[NSNumber numberWithLong:categoryModel.category_id]
                              };
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/secondCategoryList", Shop_BASEURL];
    __weak typeof(categoryModel) temp = categoryModel;
    categoryModel.secondCategories.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopSecondCategoryModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.secondCategories removeAllObjects];
            [temp.secondCategories addObjectsFromArray:returnArray];
            temp.secondCategories.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.secondCategories.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.secondCategories.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

@end
