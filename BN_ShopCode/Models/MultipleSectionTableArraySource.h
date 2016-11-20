//
//  MultipleSectionTableArraySource.h
//  
//
//  Created by Liya on 15/11/9.
//  Copyright (c) 2015年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionDataSource.h"

@interface MultipleSectionTableArraySource : NSObject<UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *sections;

- (id)initWithSections:(NSArray *)anSections;

- (id)sectionAtIndex:(NSInteger)index;
- (id)sectionAtIndexPath:(NSIndexPath *)indexPath;
- (id)itemAtIndexTagged:(id)tagged;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (void)itemDeleteAtIndexPath:(NSIndexPath *)indexPath;
- (void)resetSections:(NSArray *)anSections;
- (void)addSections:(NSArray *)anSections;
- (NSInteger)getSectionCount;
- (NSInteger)getItemCountWith:(NSInteger)index;
- (NSInteger)getItemCountWithIndexPath:(NSIndexPath *)indexPath;

- (void)setNoRegisterForCellWith:(BOOL)isNoRegister;


@end

