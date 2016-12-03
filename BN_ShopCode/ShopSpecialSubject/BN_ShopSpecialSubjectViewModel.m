//
//  BN_ShopSpecialSubjectViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectViewModel.h"
#import "NSString+Attributed.h"


@implementation BN_ShopSpecialSubjectViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.specials = [[NSMutableArray alloc] initFromNet];
        self.recommends = [[NSMutableArray alloc] initFromNet];
        self.type = 14;
        
        SectionDataSource *section0 = [self getSectionDataSourceWith:nil items:self.specials cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section1 = [self getSectionDataSourceWith:nil items:nil cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section2 = [self getSectionDataSourceWith:nil items:self.recommends cellIdentifier:nil configureCellBlock:nil];
        self.dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:@[section0, section1, section2]];
    }
    return self;
}

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
}

#pragma mark - 获取评论列表
- (void)getSpecialsData
{
    NSDictionary *paraDic = @{@"specialId" : @(self.specialId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/special/list",BASEURL];
    __weak typeof(self) temp = self;
    self.specials.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodSpecialModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.specials removeAllObjects];
            [temp.specials addObjectsFromArray:returnArray];
            temp.specials.networkTotal = [dic objectForKey:@"total"];
            
            
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.specials.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.specials.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

- (void)getTopicsData {
    NSDictionary *paraDic = @{@"specialId" : @(self.specialId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsSpecialList",BASEURL];
    __weak typeof(self) temp = self;
    self.recommends.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopSpecialTopicModel mj_objectArrayWithKeyValuesArray:array];
            
            [temp.recommends removeAllObjects];
            [temp.recommends addObjectsFromArray:returnArray];
            temp.recommends.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.recommends.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.recommends.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

- (void)getSpecialDetail {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(self.specialId), @"id", nil];
    if ([BC_ToolRequest sharedManager].token) {
        [paraDic setObject:[BC_ToolRequest sharedManager].token forKey:@"token"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/special/detail",BASEURL];
    __weak typeof(self) temp = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            temp.specialDetail = [BN_ShopSpecialDetailModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            SectionDataSource *secton = [temp.dataSource sectionAtIndex:1];
            [secton resetItems:temp.specialDetail.commentsRecord];
            temp.tagDataSource = [[TableDataSource alloc] initWithItems:temp.specialDetail.tags cellIdentifier:nil configureCellBlock:nil];
            temp.isFollow = temp.specialDetail.isCollected;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
}

#pragma mark - 
- (NSAttributedString *)realAttributedPrice:(NSString *)realPrice {
    return [[NSString stringWithFormat:@"¥%@", realPrice] setFont:Font10 restFont:Font16 range:NSMakeRange(0, 1)];
}

- (NSAttributedString *)contentAttributed:(NSString *)html {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

- (NSString *)followStrWith:(int)follwNum {
    return [NSString stringWithFormat:@"%d%@", follwNum, TEXT(@"个人喜欢")];
}

- (NSString *)collectedNumStr {
    return [NSString stringWithFormat:@"%d%@", self.specialDetail.collecteNum, TEXT(@"位达人已收藏")];
}

- (NSArray *)collectedImgs {
    NSMutableArray *array = [NSMutableArray array];
    for (BN_ShopSpecialCollectedRecordModel *record in self.specialDetail.collectedRecord) {
        [array addObject:record.userPicUrl];
    }
    return array.copy;
}
@end
