//
//  LBB_SaleAalesReasonPickerView.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_SaleAalesReasonPickerView.h"
#import <ActionSheetCustomPicker.h>

@interface LBB_SaleAalesReasonPickerView ()<ActionSheetCustomPickerDelegate>

@property (nonatomic,strong) ActionSheetCustomPicker *picker; // 选择器
@property (nonatomic,weak) UIView *parentView;
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSArray *dataSource;
@property (nonatomic,strong) LBB_SaleafterTypeModel *selectModel;
@end

@implementation LBB_SaleAalesReasonPickerView


- (void)showPickerViewWithDataSource:(NSArray<LBB_SaleafterTypeModel*>*)dataSource ParentView:(UIView*)parentView
{
    if (dataSource.count == 0) {
        return;
    }
    self.parentView = parentView;
    self.dataSource = dataSource;
    self.selectModel = [self.dataSource objectAtIndex:0];
    // 点击的时候传三个index进去
    self.picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择原因"
                                                        delegate:self
                                                showCancelButton:YES
                                                          origin:self.parentView
                                               initialSelections:@[@(self.index1)]];
    self.picker.tapDismissAction  = TapActionNone;
    [self.picker showActionSheetPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}
#pragma mark UIPickerViewDelegate Implementation

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:16]];
    }
    
    LBB_SaleafterTypeModel *cellModel = [self.dataSource objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = cellModel.display;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectModel = [self.dataSource objectAtIndex:row];
}

// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    if (self.selectBlock) {
        self.selectBlock(self.selectModel);
    }
    self.selectBlock = nil;
}

@end

