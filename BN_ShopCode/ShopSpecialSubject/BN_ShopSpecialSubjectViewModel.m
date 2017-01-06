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

- (void)setShareUrl:(NSString *)shareUrl {
    if (shareUrl == nil) {
        _shareUrl = @"";
    } else {
        _shareUrl = shareUrl;
    }
}

- (void)setShareTitle:(NSString *)shareTitle {
    if (shareTitle == nil) {
        _shareTitle = @"";
    } else {
        _shareTitle = shareTitle;
    }
}

- (void)setShareContent:(NSString *)shareContent {
    if (shareContent == nil) {
        _shareContent = @"";
    } else {
        _shareContent = shareContent;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recommends = [[NSMutableArray alloc] initFromNet];
        
        SectionDataSource *section0 = [self getSectionDataSourceWith:nil items:nil cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section1 = [self getSectionDataSourceWith:nil items:nil cellIdentifier:nil configureCellBlock:nil];
        SectionDataSource *section2 = [self getSectionDataSourceWith:nil items:self.recommends cellIdentifier:nil configureCellBlock:nil];
        self.dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:@[section0, section1, section2]];
        
        self.tagDataSource = [[TableDataSource alloc] initWithItems:nil cellIdentifier:nil configureCellBlock:nil];
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


- (void)getTopicsData {
    NSDictionary *paraDic = @{@"specialId" : @(self.specialId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/recommendSpecialList", Shop_BASEURL];
    __weak typeof(self) temp = self;
    self.recommends.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *arrays = [BN_ShopSpecialTopicModel mj_objectArrayWithKeyValuesArray:array];
            [temp.recommends removeAllObjects];
            if (arrays) {
                [temp.recommends addObjectsFromArray:arrays];
            }
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
    NSMutableDictionary *paraDic = nil;
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/specialDetail?specialId=%ld", Shop_BASEURL, self.specialId];
    __weak typeof(self) temp = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            dic = dic[@"result"];
            temp.shareUrl = dic[@"shareUrl"];
            temp.shareTitle = dic[@"shareTitle"];
            temp.shareContent = dic[@"shareContent"];
            temp.specialDetail = [BN_ShopSpecialDetailModel mj_objectWithKeyValues:dic[@"detail"]];
            temp.specialDetail.isAlreadyCollect = [dic[@"isAlreadyCollect"] intValue];
            temp.tags = [BN_ShopspecialTagModel mj_objectArrayWithKeyValuesArray:dic[@"tags"]];
            temp.specials = [BN_ShopGoodSpecialModel mj_objectArrayWithKeyValuesArray:dic[@"contentList"]];
            temp.collectedRecord = [BN_ShopSpecialCollectedRecordModel mj_objectArrayWithKeyValuesArray:dic[@"collectList"]];
            temp.commentsRecord = [BN_ShopGoodSpecialCommentModel mj_objectArrayWithKeyValuesArray:dic[@"commentPicList"]];
            SectionDataSource *secton = [temp.dataSource sectionAtIndex:1];
            [secton resetItems:temp.commentsRecord];
            temp.tagDataSource = [[TableDataSource alloc] initWithItems:temp.tags cellIdentifier:nil configureCellBlock:nil];
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
    
    NSMutableArray *strArray = [[NSMutableArray alloc]initWithArray:[html componentsSeparatedByString:@"\""]];
    [strArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj rangeOfString:@"width="].location != NSNotFound) {
            NSString *strWidth = strArray[idx + 1];
            NSString *strHeight = strArray[idx + 3];
            strHeight = [NSString stringWithFormat:@"%d",(int)((DeviceWidth*strHeight.floatValue*1.0)/strWidth.floatValue)];
            strWidth = [NSString stringWithFormat:@"%d",(int)DeviceWidth];
            strArray[idx + 1] = strWidth;
            strArray[idx + 3] = strHeight;
        }
    }];
    html = [strArray componentsJoinedByString:@"\""];
    
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return [[NSMutableAttributedString alloc] initWithString:html attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName:ColorGray}];
}

- (NSString *)followStrWith:(int)follwNum {
    return [NSString stringWithFormat:@"%d%@", follwNum, TEXT(@"个人喜欢")];
}

- (NSString *)collectedNumStr {
    return [NSString stringWithFormat:@"%d%@", self.specialDetail.total_collected, TEXT(@"位达人已收藏")];
}

- (NSArray *)collectedImgs {
    NSMutableArray *array = [NSMutableArray array];
    for (BN_ShopSpecialCollectedRecordModel *record in self.collectedRecord) {
        [array addObject:record.userPicUrl];
    }
    return array.copy;
}
@end
