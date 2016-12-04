//
//  BN_ShopSpecialSubjectViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "TableDataSource.h"
#import "BN_ShopSpecialDetailModel.h"
#import "BN_ShopSpecialTopicModel.h"


@interface BN_ShopSpecialSubjectViewModel : BN_BaseDataModel
@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) long specialId;//专题主键
@property (nonatomic, strong) NSMutableArray<BN_ShopGoodSpecialModel*> *specials;//商品的列表
@property (nonatomic, strong) NSArray<BN_ShopSpecialTopicModel*> *recommends;//推荐列表
@property (nonatomic, strong) NSArray<BN_ShopspecialTagModel*> *tags;//标签列表
@property (nonatomic, strong) NSArray<BN_ShopSpecialCollectedRecordModel*> *collectedRecord;//收藏记录（具体几个后台控制）
@property (nonatomic, strong) NSArray<BN_ShopGoodSpecialCommentModel*> *commentsRecord;//评论记录（具体几个后台控制）


@property (nonatomic, strong) BN_ShopSpecialDetailModel *specialDetail;
@property (nonatomic, strong) TableDataSource *tagDataSource;


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)getTopicsData;
- (void)getSpecialDetail;

- (NSAttributedString *)realAttributedPrice:(NSString *)realPrice;
- (NSString *)followStrWith:(int)follwNum;
- (NSString *)collectedNumStr;
- (NSAttributedString *)contentAttributed:(NSString *)html;
- (NSArray *)collectedImgs;
@end
