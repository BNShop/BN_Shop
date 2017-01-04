//
//  BN_MyCollectionToolBar.m
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/31.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_MyCollectionToolBar.h"
#import "BN_ShopHeader.h"

@interface BN_MyCollectionToolBar ()

@property (nonatomic, strong) UIButton *selectBtn; //选择全选
@property (nonatomic, strong) UILabel *tipLabel; // 全选提示框
@property (nonatomic, strong) UIButton *deleteBtn; // 删除按钮

@end

@implementation BN_MyCollectionToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(9, 9, 34, 34)];
    [self.selectBtn setImage:[UIImage imageNamed:@"Shop_ShoppingCart_Unselected"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"Shop_ShoppingCart_Selected"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame), 15.5, 80, 21)];
    self.tipLabel.text = TEXT(@"全选");
    self.tipLabel.font = Font15;
    [self addSubview:self.tipLabel];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 105, 0, 105, 52)];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = Font15;
    self.deleteBtn.backgroundColor = ColorBtnYellow;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = ColorLine;
    [self addSubview:line];
}

- (void)selectBtnClick {
    self.selectBtn.selected = !self.selectBtn.selected;
    BOOL isSelect = self.selectBtn.selected;
    self.tipLabel.text = self.selectBtn.selected?TEXT(@"取消全选") : TEXT(@"全选");
    if (self.selectAll) {
        self.selectAll(isSelect);
    }
}

- (void)deleteBtnClick {
    
    if (self.deleteClick) {
        self.deleteClick();
    }
    self.selectBtn.selected = NO;
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
//    self.selectBtn.selected = edit;
    self.tipLabel.text = self.selectBtn.selected?TEXT(@"取消全选") : TEXT(@"全选");
}

@end
