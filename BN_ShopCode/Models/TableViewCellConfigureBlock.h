//
//  TableViewCellConfigureBlock.h
//  BN_Shop
//
//  Created by Liya on 16/11/12.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#ifndef TableViewCellConfigureBlock_h
#define TableViewCellConfigureBlock_h
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);
typedef void (^TableViewSectionConfigureBlock)(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath);

#endif /* TableViewCellConfigureBlock_h */
