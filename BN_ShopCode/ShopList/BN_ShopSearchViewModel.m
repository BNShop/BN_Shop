//
//  BN_ShopSearchViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSearchViewModel.h"
#import "BN_ShopspecialTagModel.h"

@interface BN_ShopSearchViewModel ()

@end

static NSString * const BN_ShopSearchCache = @"searchs.plist";
static NSString * const BN_ShopSearchRecentlyCache = @"Recently";
static NSString * const BN_ShopSearchHotCache = @"Hot";

@implementation BN_ShopSearchViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title tagged:(id)tagged items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    sectionDataSource.configureSectionBlock = configureSectionBlock;
    sectionDataSource.sectionIdentifier = sectionIdentifier;
    sectionDataSource.tagged = tagged;
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}


- (NSArray *)getRecentlySearchCache {
    NSString *filepath = [CachePath stringByAppendingPathComponent:BN_ShopSearchCache];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    NSArray *searchs = [dic objectForKey:BN_ShopSearchRecentlyCache];
    if ([searchs isEqual:[NSNull null]] || ![searchs isKindOfClass:[NSArray class]]) {
        return @[];
    } else {
        return searchs.copy;
    }
}

- (NSArray *)getHotSearchCache {
    NSString *filepath = [CachePath stringByAppendingPathComponent:BN_ShopSearchCache];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    NSArray *searchs = [dic objectForKey:BN_ShopSearchHotCache];
    if ([searchs isEqual:[NSNull null]] || ![searchs isKindOfClass:[NSArray class]]) {
        return @[];
    } else {
        return searchs.copy;
    }
}


- (void)cacheSearchs {
    NSString *filepath = [CachePath stringByAppendingPathComponent:BN_ShopSearchCache];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    SectionDataSource *section = [self.dataSource sectionAtIndex:0];
    if (!section.tagged && section.getItemsCount) {
        [dic setObject:section.items forKey:BN_ShopSearchRecentlyCache];
    }
    section = [self.dataSource sectionAtIndex:1];
    if (!section.tagged && section.getItemsCount) {
        [dic setObject:section.items forKey:BN_ShopSearchHotCache];
    }
    [dic writeToFile:filepath atomically:YES];
}


- (void)addSearchToLocalWith:(NSString *)search {
    if (search) {
        SectionDataSource *section = [self.dataSource sectionAtIndex:0];
        if (section.tagged) {
            [section resetItems:@[search]];
            section.tagged = nil;
        } else {
            if (![section.items containsObject:search]) {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:search];
                if (section.items) [array addObjectsFromArray:section.items];
                [section resetItems:array];
            } else {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:search];
                [section.items removeObject:search];
                if (section.items) [array addObjectsFromArray:section.items];
                [section resetItems:array];
            }
            
        }
        if (section.getItemsCount > 9) {
            [section.items removeObjectsInRange:NSMakeRange(9, section.getItemsCount-9)];
        }
        
        [self cacheSearchs];
    }
}


- (void)delSearchLocal {
    SectionDataSource *section = [self.dataSource sectionAtIndex:0];
    [section resetItems:@[TEXT(@"暂无最近搜索")]];
    section.tagged = TEXT(@"最近搜索");
    [self cacheSearchs];
}

- (void)resetSearchsToHotWith:(NSArray *)searchs {
    if ([searchs count] > 0) {
        SectionDataSource *section = [self.dataSource sectionAtIndex:1];
        [section resetItems:searchs];
    }
}

- (id)validSearch:(NSIndexPath *)indexPath {
    SectionDataSource *section = [self.dataSource sectionAtIndex:indexPath.section];
    if (section.tagged) {
        return nil;
    }
    return [section itemAtIndexPath:indexPath];
}

- (void)getHotSearchTagsDataRes {
    NSString *url = [NSString stringWithFormat:@"%@/homePage/hot/tags",BASEURL];
    __weak typeof(self) temp = self;
    self.tags.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopspecialTagModel mj_objectArrayWithKeyValuesArray:array];
            [temp.tags removeAllObjects];
            for (BN_ShopspecialTagModel *tag in returnArray) {
                [self.tags addObject:tag.tagName];
            }
            temp.tags.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.tags.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.tags.loadSupport.loadEvent = NetLoadFailedEvent;
    }];

}

@end
