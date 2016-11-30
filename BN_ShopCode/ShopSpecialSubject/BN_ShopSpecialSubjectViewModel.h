//
//  BN_ShopSpecialSubjectViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "BN_ShopGoodCommentsModel.h"
#import "BN_ShopGoodSpecialModel.h"


@interface BN_ShopSpecialSubjectViewModel : NSObject
@property (nonatomic, strong) MultipleSectionTableArraySource *dataSource;
@property (nonatomic, assign) BOOL isFollow;
@property (assign, nonatomic) long specialId;//专题主键
@property (assign, nonatomic) int type;

@property (nonatomic, strong) NSMutableArray<BN_ShopGoodSpecialModel*> *specials;
@property (nonatomic, strong) NSMutableArray<BN_ShopGoodCommentsModel*> *comments;
@property (nonatomic, strong) NSMutableArray *topics;


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)getSpecialsData;
- (void)getCommentsClearData:(BOOL)clear;
- (void)getTopicsData;

- (NSAttributedString *)realAttributedPrice:(NSString *)realPrice;
- (NSString *)followStrWith:(int)follwNum;
- (NSAttributedString *)contentAttributed:(NSString *)html;

@end
