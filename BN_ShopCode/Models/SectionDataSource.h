//
//  SectionDataSource.h
//  
//
//  Created by Liya on 15/11/9.
//  Copyright (c) 2015年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewCellConfigureBlock.h"

@interface SectionDataSource : NSObject

@property (nonatomic, strong) id tagged;//对应的标志，有可能是字符串等
@property (nonatomic, copy) NSString *Title;//对应标题
@property (nonatomic, copy) NSString *Icon;//对应图标

@property (nonatomic, strong) NSMutableArray *items;//对应的
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *sectionIdentifier;
@property (nonatomic, copy) NSString *cellClassName;
@property (nonatomic, assign) BOOL isCellNib;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) TableViewSectionConfigureBlock configureSectionBlock;

- (id)initWithItems:(NSArray *)anItems
              title:(NSString *)title;

- (NSInteger)indexOfItme:(id)item;
- (id)itemAtIndex:(NSInteger)index;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (void)itemDelIndexPath:(NSIndexPath *)indexPath;
- (void)resetItems:(NSArray *)anItems;
- (void)addItems:(NSArray *)anItems;
- (NSInteger)getItemsCount;
- (void)deleteItemWithObj:(id)obj;
- (void)deleteItemWithItems:(NSArray *)anItems;
@end
