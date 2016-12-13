//
//  LBB_SaleAalesReasonPickerView.h
//  BN_Shop
//
//  Created by 美少男 on 16/12/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBB_OrderModel.h"

typedef void(^SaleAalesReasonBlock)(LBB_SaleafterTypeModel *selectModel);

@interface LBB_SaleAalesReasonPickerView : NSObject

@property(nonatomic,strong) SaleAalesReasonBlock selectBlock;

- (void)showPickerViewWithDataSource:(NSArray<LBB_SaleafterTypeModel*>*)dataSource ParentView:(UIView*)parentView;

@end
