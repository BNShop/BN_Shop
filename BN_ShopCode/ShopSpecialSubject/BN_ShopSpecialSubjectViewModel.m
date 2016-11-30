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
        self.comments = [[NSMutableArray alloc] initFromNet];
        self.specials = [[NSMutableArray alloc] initFromNet];
        self.topics = [[NSMutableArray alloc] initFromNet];
        self.type = 14;
        
        SectionDataSource *section0 = [self getSectionDataSourceWith:nil items:self.specials cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section1 = [self getSectionDataSourceWith:nil items:self.comments cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section2 = [self getSectionDataSourceWith:nil items:self.topics cellIdentifier:nil configureCellBlock:nil];
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
- (void)getCommentsClearData:(BOOL)clear
{
    int curPage = clear == YES ? 0 : round(self.comments.count/10.0);
    NSDictionary *paraDic = @{@"objId" : @(self.specialId),
                              @"type" : @(self.type),
                              @"curPage" : @(curPage),
                              @"pageNum" : @1};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/commentLists",BASEURL];
    __weak typeof(self) temp = self;
    self.comments.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_ShopGoodCommentsModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear) {
                [temp.comments removeAllObjects];
            }
            [temp.comments addObjectsFromArray:returnArray];
            temp.comments.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.comments.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.comments.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}

- (void)getSpecialsData
{
    NSDictionary *paraDic = @{@"specialId" : @(self.specialId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsSpecialList",BASEURL];
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
@end
