//
//  BN_ShopScreeningConditionsViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningConditionsViewModel.h"
#import "NSArray+BlocksKit.h"

@interface BN_ShopScreeningConditionsViewModel ()

@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;

@end

@implementation BN_ShopScreeningConditionsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.conditions = [[NSMutableArray alloc] init];
    }
    return self;
}


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier sectionIdentifier:(NSString *)sectionIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
        SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
        sectionDataSource.cellIdentifier = cellIdentifier;
        sectionDataSource.configureCellBlock = configureCellBlock;
        sectionDataSource.configureSectionBlock = configureSectionBlock;
        sectionDataSource.sectionIdentifier = sectionIdentifier;
        
        return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}

- (void)getConditionTagsWith:(BN_ShopConditionModel *)condition {
    
    NSDictionary *paraDic = @{@"type":[NSNumber numberWithInt:condition.type], @"classes":[NSNumber numberWithInt:condition.classes]};
    
    NSString *url = [NSString stringWithFormat:@"%@/homePage/condition/tags", BASEURL];
    __weak typeof(condition) temp = condition;
    condition.tags.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"url = %@", operation.currentRequest);
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopConditionTagModel mj_objectArrayWithKeyValuesArray:array];
            
//            [temp.tags removeAllObjects];
            [temp.tags addObjectsFromArray:returnArray];
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

#pragma mark - 
- (void)buildConditionsWith:(int)classes {
    BN_ShopConditionTagModel *tag = [[BN_ShopConditionTagModel alloc] init];
    tag.tagId = 0;
    tag.tagName = TEXT(@"不限");
    
    BN_ShopConditionModel *brandCondition = [[BN_ShopConditionModel alloc] init];
    brandCondition.classes = classes;
    brandCondition.type = BN_ShopConditionTag_Brand;
    brandCondition.iconUrl = @"Shop_Screen_Brand";
    brandCondition.name = TEXT(@"品牌");
    [brandCondition.tags addObject:tag];
    BN_ShopConditionModel *suitCondition = [[BN_ShopConditionModel alloc] init];
    suitCondition.classes = classes;
    suitCondition.type = BN_ShopConditionTag_Suit;
    suitCondition.iconUrl = @"Shop_Screen_Crowd";
    suitCondition.name = TEXT(@"适合人群");
    [suitCondition.tags addObject:tag];
    BN_ShopConditionModel *priceCondition = [[BN_ShopConditionModel alloc] init];
    priceCondition.classes = classes;
    priceCondition.type = BN_ShopConditionTag_Price;
    priceCondition.iconUrl = @"Shop_Screen_Price";
    priceCondition.name = TEXT(@"价格");
    [priceCondition.tags addObject:tag];
    [self.conditions addObject:brandCondition];
    [self.conditions addObject:suitCondition];
    [self.conditions addObject:priceCondition];
}
#pragma mark - 选中的标签
- (NSInteger)curTagIndexWith:(int)type tagId:(long)tagId {
    BN_ShopConditionModel *condition = [self.conditions bk_match:^BOOL(BN_ShopConditionModel *obj) {
        return obj.type == type;
    }];
    BN_ShopConditionTagModel *tag = [condition.tags bk_match:^BOOL(BN_ShopConditionTagModel *obj) {
        return obj.tagId == tagId;
    }];
    if (tag && [condition.tags containsObject:tag]) {
        return [condition.tags indexOfObject:tag];
    }
    return 0;
}

- (NSInteger)curBankIndex {
    return [self curTagIndexWith:BN_ShopConditionTag_Brand tagId:self.brandTagId];
}

- (NSInteger)curSuitIndex {
    return [self curTagIndexWith:BN_ShopConditionTag_Suit tagId:self.suitTagId];
}

- (NSInteger)curPriceIndex {
    return [self curTagIndexWith:BN_ShopConditionTag_Price tagId:self.priceTagId];
}


#warning 获取当前的赌赢配置
- (void)curBankTagIdWith:(NSIndexPath *)indexPath {
    
    BN_ShopConditionModel *condition = [self.conditions bk_match:^BOOL(BN_ShopConditionModel *obj) {
        return obj.type == BN_ShopConditionTag_Brand;
    }];
    BN_ShopConditionTagModel *tag = nil;
    if (indexPath.row < condition.tags.count) {
        tag = [condition.tags objectAtIndex:indexPath.row];
    }
    self.brandTagId = tag.tagId;
}

- (void)curPriceTagIdWith:(NSIndexPath *)indexPath {
    BN_ShopConditionModel *condition = [self.conditions bk_match:^BOOL(BN_ShopConditionModel *obj) {
        return obj.type == BN_ShopConditionTag_Price;
    }];
    BN_ShopConditionTagModel *tag = nil;
    if (indexPath.row < condition.tags.count) {
        tag = [condition.tags objectAtIndex:indexPath.row];
    }
    self.priceTagId = tag.tagId;
}

- (void)curSuitTagIdWith:(NSIndexPath *)indexPath {
    BN_ShopConditionModel *condition = [self.conditions bk_match:^BOOL(BN_ShopConditionModel *obj) {
        return obj.type == BN_ShopConditionTag_Suit;
    }];
    BN_ShopConditionTagModel *tag = nil;
    if (indexPath.row < condition.tags.count) {
        tag = [condition.tags objectAtIndex:indexPath.row];
    }
    self.suitTagId = tag.tagId;
}

@end
