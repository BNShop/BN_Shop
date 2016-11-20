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
        NSIndexPath *indexPath = [indexpaths bk_match:^BOOL(id obj) {
            if ([(NSIndexPath *)obj section] == 0) {
                return YES;
            }
            return NO;
        }];
        [self.viewModel curBankNameWith:indexPath];
        indexPath = [indexpaths bk_match:^BOOL(id obj) {
            if ([(NSIndexPath *)obj section] == 1) {
                return YES;
            }
            return NO;
        }];
        [self.viewModel curTagIDNameWith:indexPath];
        NSArray *array = [indexpaths bk_select:^BOOL(id obj) {
            if ([(NSIndexPath *)obj section] == 3) {
                return YES;
            }
            return NO;
        }];
        [self.viewModel curSuitableWith:array];
        
        if ([self.delegate respondsToSelector:@selector(screeningConditionsWith:tagID:suitable:priceStart:priceEnd:)]) {
            [self screeningConditionsWith:self.viewModel.brandName tagID:self.viewModel.tagID suitable:self.viewModel.suitable priceStart:self.viewModel.priceStart priceEnd:self.viewModel.priceEnd];
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
    self.viewModel = [[BN_ShopScreeningConditionsViewModel alloc] init];
    [self testObects];
#warning 初始化列表数据等等
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else if (indexPath.section != 2 && indexPath.section != 3) {
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
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != 2;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        CGFloat width = (WIDTH(collectionView) - 5*2 - 14*2) / 3.0;
        return CGSizeMake(width, 26);
    } else {
        CGFloat width = (WIDTH(collectionView) - 14*2);
        return CGSizeMake(width, 40);
    }
    
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

#pragma mark - data source test

- (void)testObects {
    NSString *tag = @"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元";
    NSArray *titles = @[@"品牌", @"标签", @"价格", @"合适人群"];
    NSArray *images = @[@"Shop_Screen_Brand", @"Shop_Screen_Tag", @"Shop_Screen_Price", @"Shop_Screen_Crowd"];
    for (NSInteger i=0; i<4; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j=0; j<i+5; j++) {
            [array addObject:[tag substringWithRange:NSMakeRange(random()%40, random()%7+1)]];
        }
        
        SectionDataSource *section = nil;
        NSString *title = [titles objectAtIndex:i];
        if ([title isEqualToString:@"价格"]) {
            @weakify(self);
            section = [self.viewModel getSectionDataSourceWith:title items:[array subarrayWithRange:NSMakeRange(0, 1)] cellIdentifier:ShopScreeningConditionsPriceCellIdentifier sectionIdentifier:ShopScreeningSupplementaryIdentifier configureCellBlock:^(id cell, id item) {
                [(BN_ShopScreeningResuablePriceCell *)cell updateWith:self.viewModel.priceStart maxPrice:self.viewModel.priceEnd];
                [(BN_ShopScreeningResuablePriceCell *)cell setPriceChangedBlock:^(NSString *text, NSInteger indexPath) {
                    @strongify(self);
                    if (indexPath == 0) {
                        self.viewModel.priceStart = text;
                    } else if (indexPath == 1) {
                        self.viewModel.priceEnd = text;
                    }
                }];
                
            } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
                [(BN_ShopScreeningReusableView *)view updateWith:[(SectionDataSource *)sectionDataSource Icon] title:[(SectionDataSource *)sectionDataSource Title]];
            }];
        } else {
           section = [self.viewModel getSectionDataSourceWith:title items:array cellIdentifier:ShopScreeningConditionsCellIdentifier sectionIdentifier:ShopScreeningSupplementaryIdentifier configureCellBlock:^(id cell, id item) {
                [(BN_ShopBannerCell *)cell updateWith:item];
            } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
                [(BN_ShopScreeningReusableView *)view updateWith:[(SectionDataSource *)sectionDataSource Icon] title:[(SectionDataSource *)sectionDataSource Title]];
            }];
        }
        
        [self.viewModel addDataSourceWith:section];
        section.Icon = [images objectAtIndex:i];
        
        
    }
    self.collectionView.dataSource = self.viewModel.dataSource;
    [self.collectionView reloadData];
    for (NSIndexPath *indexpath in self.viewModel.curIndexsInScreening) {
        [self.collectionView selectItemAtIndexPath:indexpath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    
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
    
    signal = [[self rac_signalForSelector:@selector(screeningConditionsWith:tagID:suitable:priceStart:priceEnd:) fromProtocol:@protocol(BN_ShopScreeningConditionsViewControllerProtocol)] map:^id(RACTuple *tuple) {
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
