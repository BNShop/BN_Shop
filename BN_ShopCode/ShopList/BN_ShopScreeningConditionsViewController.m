//
//  TestViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopScreeningConditionsViewController.h"
#import "BN_ShopSearchViewModel.h"
#import "BN_ShopScreeningConditionsViewModel.h"
#import "NSArray+BlocksKit.h"
#import "PureLayout.h"
#import "UIView+BlocksKit.h"

#import "BN_ShopBannerCell.h"
#import "BN_ShopScreeningReusableView.h"
#import "BN_ShopScreeningResuablePriceCell.h"
#import "BN_ShopScreeningToolBar.h"



@interface BN_ShopScreeningConditionsViewController ()<UICollectionViewDelegate, BN_ShopScreeningConditionsViewControllerProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopScreeningToolBar *toolBar;

@property (strong, nonatomic) BN_ShopScreeningConditionsViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

static NSString * const ShopScreeningConditionsCellIdentifier = @"ShopScreeningConditionsCellIdentifier";
static NSString * const ShopScreeningConditionsPriceCellIdentifier = @"ShopScreeningConditionsPriceCellIdentifier";
static NSString * const ShopScreeningSupplementaryIdentifier = @"ShopScreeningSupplementaryIdentifier";

@implementation BN_ShopScreeningConditionsViewController

- (instancetype)initWithBankTagId:(long)bankTagId priceTagId:(long)priceTagId suitTagId:(long)suitTagId
{
    self = [super init];
    if (self) {
        self.viewModel = [[BN_ShopScreeningConditionsViewModel alloc] init];
        self.viewModel.brandTagId = bankTagId;
        self.viewModel.priceTagId = priceTagId;
        self.viewModel.suitTagId = suitTagId;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [self.collectionView registerNib:[BN_ShopBannerCell nib] forCellWithReuseIdentifier:ShopScreeningConditionsCellIdentifier];
    [self.collectionView registerNib:[BN_ShopScreeningReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopScreeningSupplementaryIdentifier];
    [self.collectionView registerNib:[BN_ShopScreeningResuablePriceCell nib] forCellWithReuseIdentifier:ShopScreeningConditionsPriceCellIdentifier];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.toolBar = [BN_ShopScreeningToolBar nib];
    [self.view addSubview:self.toolBar];
    @weakify(self);
    [self.toolBar addOkEventHandler:^(id sender) {
        @strongify(self);
        NSArray *indexpaths = [self.collectionView indexPathsForSelectedItems];
        for (NSIndexPath *indexpath in indexpaths) {
            if (indexpath.section == 0) {
                [self.viewModel curBankTagIdWith:indexpath];
            } else if (indexpath.section == 1) {
                [self.viewModel curSuitTagIdWith:indexpath];
            } else if (indexpath.section == 2) {
                [self.viewModel curPriceTagIdWith:indexpath];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(screeningConditionsWith:suitTagId:bankTagId:)]) {
            [self screeningConditionsWith:self.viewModel.priceTagId suitTagId:self.viewModel.suitTagId bankTagId:self.viewModel.brandTagId];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.toolBar addCancleEventHandler:^(id sender) {
// 仅仅只是跳回，选择的数据页不保存，这就是为什么要用collectionview来作为单选，而不是直接数据判断
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(dismissConditions)]) {
            [self.delegate dismissConditions];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.topView bk_whenTapped:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(dismissConditions)]) {
            [self.delegate dismissConditions];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
- (void)setControlsFrame {
    
    [self.toolBar autoSetDimension:ALDimensionHeight toSize:[self.toolBar getViewHeight]];
    [self.toolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-80.0f];
}

#pragma mark - viewModel
- (void)buildViewModel {
    if (!self.viewModel) {
        self.viewModel = [[BN_ShopScreeningConditionsViewModel alloc] init];
    }
    [self.viewModel buildConditionsWith:BN_ShopConditionClasses_Souvenir];
    [self.collectionView setBn_data:self.viewModel.conditions];
    for (BN_ShopConditionModel *condition in self.viewModel.conditions) {
        SectionDataSource *sectionDataSource = [self.viewModel getSectionDataSourceWith:condition.name items:condition.tags cellIdentifier:ShopScreeningConditionsCellIdentifier sectionIdentifier:ShopScreeningSupplementaryIdentifier configureCellBlock:^(id cell, BN_ShopConditionTagModel *item) {
            [(BN_ShopBannerCell *)cell updateWith:item.tagName];
        } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
            [(BN_ShopScreeningReusableView *)view updateWith:[(SectionDataSource *)sectionDataSource Icon] title:[(SectionDataSource *)sectionDataSource Title]];
        }];
        sectionDataSource.Icon = condition.iconUrl;
        sectionDataSource.Title = condition.name;
        [self.viewModel addDataSourceWith:sectionDataSource];
    }
    self.collectionView.dataSource = self.viewModel.dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        for (NSInteger index=0; index<3; index++) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
    
    for (BN_ShopConditionModel *condition in self.viewModel.conditions) {
        @weakify(self);
        @weakify(condition);
        [condition.tags.loadSupport setDataRefreshblock:^{
            @strongify(self);
            @strongify(condition);
            NSInteger index = [self.viewModel.conditions indexOfObject:condition];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:NO];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.viewModel curPriceIndex] inSection:2] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.viewModel curBankIndex] inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.viewModel curSuitIndex] inSection:1] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
            
        }];
        
        [self.viewModel getConditionTagsWith:condition];
        
    }
    

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexpaths = [collectionView indexPathsForSelectedItems];
    NSIndexPath *preIndexPath = [indexpaths bk_match:^BOOL(id obj) {
        if ([(NSIndexPath *)obj compare:indexPath] != NSOrderedSame && [(NSIndexPath *)obj section] == indexPath.section) {
            return YES;
        }
        return FALSE;
    }];
    if (preIndexPath) {
        [collectionView deselectItemAtIndexPath:preIndexPath animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (WIDTH(collectionView) - 5*2 - 14*2) / 3.0;
    return CGSizeMake(width, 26);
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 14, 6, 14);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(WIDTH(collectionView), 36.0f);
}

@end

@implementation BN_ShopScreeningConditionsViewController (RAC)
- (RACSignal *)rac_screeningConditionsSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(screeningConditionsWith:suitTagId:bankTagId:) fromProtocol:@protocol(BN_ShopScreeningConditionsViewControllerProtocol)] map:^id(RACTuple *tuple) {
        return tuple.allObjects;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_dismissConditionsSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(dismissConditions) fromProtocol:@protocol(BN_ShopScreeningConditionsViewControllerProtocol)] map:^id(RACTuple *tuple) {
        return tuple;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}
@end
