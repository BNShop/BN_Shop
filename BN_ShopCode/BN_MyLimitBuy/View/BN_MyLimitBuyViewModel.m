//
//  BN_MyLimitBuyViewModel.m
//  BN_Shop
//
//  Created by yuze_huang on 2017/1/3.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import "BN_MyLimitBuyViewModel.h"
#import "NSDictionary+BlocksKit.h"
#import "NSArray+BlocksKit.h"
#import "NSString+Attributed.h"
#import "NSError+Description.h"

@implementation BN_MyLimitBuyViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.collectionList = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
    
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    sectionDataSource.configureSectionBlock = configureSectionBlock;
    sectionDataSource.sectionIdentifier = nil;
    
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}

//删除选中的选项
- (void)clearSelectedItems {
    NSMutableArray *matchs = [NSMutableArray array];
    for (SectionDataSource *sectionDataSource in self.dataSource.sections) {
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_MycollectionModel *obj) {
            return [obj isSelected];
        }];
        if (match) {
            [sectionDataSource deleteItemWithItems:match];
            [self.collectionList removeObjectsInArray:match];
        }
        if (sectionDataSource.getItemsCount == 0) {
            [matchs addObject:sectionDataSource];
        }
    }
    [self.dataSource.sections removeObjectsInArray:matchs];
}

- (NSArray *)settlementSelectedItems {
    NSMutableArray *matchs = [NSMutableArray array];
    for (SectionDataSource *sectionDataSource in self.dataSource.sections) {
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_MycollectionModel *obj) {
            return [obj isSelected];
        }];
        if (match) {
            [matchs addObjectsFromArray:match];
        }
    }
    return matchs;
}

- (NSInteger)selectedItemCount {
    __block NSInteger count = 0;
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        NSArray *match = [sectionDataSource.items bk_select:^BOOL(BN_MycollectionModel *obj) {
            return [obj isSelected];
        }];
        count += [match count];
    }];
    
    return count;
}


- (NSAttributedString *)settlementCount {
    NSString *price = [NSString stringWithFormat:@"%@(%ld)", TEXT(@"结算"), (long)[self selectedItemCount]];
    return [price setFont:Font15 restFont:(UIFont *)Font10 range:[price rangeOfString:TEXT(@"结算")]];
}

- (void)selectAll:(BOOL)isSelectedAll {
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        [sectionDataSource.items bk_each:^(BN_MycollectionModel *obj) {
            [obj  setSelected:isSelectedAll];
        }];
        
    }];
    
}

- (void)isEditCell:(BOOL)isEditCell
{
    [self.dataSource.sections bk_each:^(id obj) {
        SectionDataSource *sectionDataSource = (SectionDataSource *)obj;
        [sectionDataSource.items bk_each:^(BN_MycollectionModel *obj) {
            [obj setEdit:isEditCell];
        }];
    }];
}

#pragma mark - 收藏列表获取
- (void)getCollectionListData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.collectionList.count/10.0);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:curPage], @"curPage", [NSNumber numberWithInt:10], @"pageNum",[NSNumber numberWithInt:2], @"type", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/collectGoodsList", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.collectionList.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_MycollectionModel mj_objectArrayWithKeyValuesArray:array];
            [returnArray bk_each:^(BN_MycollectionModel *obj) {
                obj.selected = YES;
            }];
            if (clear == YES)
            {
                temp.dataSource = [[MultipleSectionTableArraySource alloc] init];
                [temp.collectionList removeAllObjects];
            }
            
            [temp.collectionList addObjectsFromArray:returnArray];
            temp.collectionList.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.collectionList.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.collectionList.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

#pragma amrk - 删除收藏
- (void)deletecollection:(NSArray *)collectionIds success:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSString *collectionIdsStr = [collectionIds componentsJoinedByString:@","];
    NSMutableDictionary *paraDic = nil;//[NSMutableDictionary dictionary];
    paraDic[@"collectIds"] = collectionIdsStr;
    NSString *url = [NSString stringWithFormat:@"%@/mall/deleteCollect?bachDeleteCollect=%@", Shop_BASEURL, collectionIdsStr];
    @weakify(self);
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        @strongify(self);
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            [self clearSelectedItems];
            if (success) {
                success();
            }
        }
        
        self.collectionList.loadSupport.loadEvent = NetLoadSuccessfulEvent;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

#pragma mark - 设置提醒
//设置提醒已否
- (void)warnORCancelRes:(BOOL)isWarn goodsId:(long)goodsId success:(void(^)(long warn_id))success failure:(void(^)(NSString *errorDescription))failure {
    NSDictionary *paraDic = nil;
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/warn?goodsId=%ld", Shop_BASEURL, goodsId];
    if (!isWarn) {
        url = [NSString stringWithFormat:@"%@/mall/cancelWarn?warnId=%ld", Shop_BASEURL, goodsId];
    }
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            NSLog(@"dic = %@", dic);
            dic = dic[@"result"];
            if (success) {
                if (isWarn) {
                    long warn_id = [dic[@"warnId"] longValue];
                    success(warn_id);
                } else {
                    success(-1);
                }
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
    
}


@end
