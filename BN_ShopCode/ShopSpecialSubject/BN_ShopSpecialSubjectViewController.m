//
//  BN_ShopSpecialSubjectViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectViewController.h"
#import "UIBarButtonItem+BlocksKit.h"

#import "BN_ShopSpecialSubjectViewModel.h"

#import "BN_ShopSpecialSubjectTipCell.h"
#import "BN_ShopSpecialSubjectCell.h"
#import "BN_ShopSpecialSubjectHeadView.h"

#import "BN_ShopSpecialTopicHeadView.h"
#import "BN_ShopSpecialTopicCell.h"

#import "BN_ShopSpecialCommentCell.h"
#import "BN_ShopSpecialCommentFootView.h"
#import "BN_ShopSpecialCommentHeadView.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "NSString+Attributed.h"



@interface BN_ShopSpecialSubjectViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BN_ShopSpecialSubjectViewModel *viewModel;

@property (nonatomic, strong) BN_ShopSpecialSubjectHeadView *subjectHeadView;
@property (nonatomic, strong) BN_ShopSpecialTopicHeadView *topicHeadView;
@property (nonatomic, strong) BN_ShopSpecialCommentFootView *commentFootView;
@property (nonatomic, strong) BN_ShopSpecialCommentHeadView *commentHeadView;

@property (nonatomic, strong) UIBarButtonItem *followBarItem;

@end

static NSString * const ShopSpecialSubjectCellIdentifier = @"ShopSpecialSubjectCellIdentifier";
static NSString * const ShopSpecialSubjectTipCellIdentifier = @"ShopSpecialSubjectTipCellIdentifier";
static NSString * const ShopSpecialTopicCellIdentifier = @"ShopSpecialTopicCellIdentifier";
static NSString * const ShopSpecialCommentCellIdentifier = @"ShopSpecialCommentCellIdentifier";

@implementation BN_ShopSpecialSubjectViewController

- (instancetype)initWith:(long)specialId
{
    self = [super init];
    if (self) {
        
        self.viewModel = [[BN_ShopSpecialSubjectViewModel alloc] init];
        self.viewModel.specialId = specialId;
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

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] bk_initWithImage:IMAGE(@"Shop_SpecialSubject_NavShare") style:UIBarButtonItemStylePlain handler:^(id sender) {
#warning 分享操作
    }];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] bk_initWithImage:IMAGE(@"Shop_SpecialSubject_UnFollow") style:UIBarButtonItemStylePlain handler:^(id sender) {
#warning 收藏操作
    }];
    item0.tintColor = ColorBlack;
    item1.tintColor = ColorBlack;
    self.navigationItem.rightBarButtonItems = @[item0, item1];
    
    self.followBarItem = item1;
    [self updateFollowBarItem];
}

- (void)buildControls {
    [super buildControls];
    [self.tableView registerNib:[BN_ShopSpecialCommentCell nib] forCellReuseIdentifier:ShopSpecialCommentCellIdentifier];
    [self.tableView registerNib:[BN_ShopSpecialTopicCell nib] forCellReuseIdentifier:ShopSpecialTopicCellIdentifier];
    [self.tableView registerNib:[BN_ShopSpecialSubjectCell nib] forCellReuseIdentifier:ShopSpecialSubjectCellIdentifier];
    
    [self buildTopicHeadView];
    [self buildCommentFootView];
    [self buildCommentHeadView];
    [self buildSubjectHeadView];
}

#pragma mark - NAV's UI
- (void)updateFollowBarItem {
    if (self.viewModel.isFollow) {
        [self.followBarItem setImage:IMAGE(@"Shop_SpecialSubject_Follow")];
        self.followBarItem.tintColor = ColorRed;
    } else {
        [self.followBarItem setImage:IMAGE(@"Shop_SpecialSubject_UnFollow")];
        self.followBarItem.tintColor = ColorBlack;
    }
}

#pragma mark - viewModel

- (void)buildSubjectViewModel {
    if (!self.viewModel) {
        self.viewModel = [[BN_ShopSpecialSubjectViewModel alloc] init];
    }
    
    SectionDataSource *commentSection = [self.viewModel.dataSource sectionAtIndex:1];
    commentSection.cellIdentifier = ShopSpecialCommentCellIdentifier;
    commentSection.configureCellBlock = ^(id cell, BN_ShopGoodSpecialCommentModel *item){
        [(BN_ShopSpecialCommentCell *)cell updateWith:nil comentNum:[NSString stringWithFormat:@"%d",item.commentsNum] follow:NO];
        [(BN_ShopSpecialCommentCell *)cell updateWith:item.userPicUrl name:item.userName content:item.remark date:item.commentDate];
        [(BN_ShopSpecialCommentCell *)cell updateWith:item.pics];
    };
    @weakify(self);
    SectionDataSource *specialsSection = [self.viewModel.dataSource sectionAtIndex:0];
    specialsSection.cellIdentifier = ShopSpecialSubjectCellIdentifier;
    specialsSection.configureCellBlock = ^(id cell, BN_ShopGoodSpecialModel *item){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [(BN_ShopSpecialSubjectCell *)cell updateWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row] title:item.titleDisplay subTitle:item.viceTitleDisplay content:[self.viewModel contentAttributed:item.contentDisplay] follow:[NSString stringWithFormat:@"%d",item.likeNum] price:[self.viewModel realAttributedPrice:item.real_price]];
        [(BN_ShopSpecialSubjectCell *)cell updateWith:item.imageUrl1 subImgUrl:item.imageUrl2 completed:^(id cell) {
            @strongify(self);
            NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
            if (indexpath) {
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
        }];
        [(BN_ShopSpecialSubjectCell *)cell  clickedAction:^(id sender) {
#warning 点击购买做什么呢
            @strongify(self);
            
        }];
    };
    
    SectionDataSource *tipsSection = [self.viewModel.dataSource sectionAtIndex:2];
    tipsSection.cellIdentifier = ShopSpecialTopicCellIdentifier;
    tipsSection.configureCellBlock = ^(id cell, BN_ShopSpecialTopicModel *item){
        [(BN_ShopSpecialTopicCell *)cell updateWith:item.cover_img title:item.name subTitle:item.content tip:item.tagName];
    };
    [self.view setBn_data:self.viewModel];
    [self.view setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getSpecialDetail];
    }];
    [self.viewModel.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.viewModel.tagDataSource resetellIdentifier:ShopSpecialSubjectTipCellIdentifier configureCellBlock:^(id cell, BN_ShopspecialTagModel *item) {
            [(BN_ShopSpecialSubjectTipCell *)cell updateWith:item.tagName];
        }];
        [self buildSubjectHeadView];
        [self buildCommentHeadView];
        [self.tableView reloadData];
        [self buildSpecialsData];
    }];
    [self.viewModel getSpecialDetail];
    
}

- (void)buildSpecialsData {
    @weakify(self);
    [self.subjectHeadView setBn_data:self.viewModel.specials];
    [self.subjectHeadView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getSpecialsData];
    }];
    [self.viewModel.specials.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.tableView reloadData];
        [self buildTopicsData];
    }];
    [self.viewModel getSpecialsData];
    
}

- (void)buildTopicsData {
    @weakify(self);
    [self.topicHeadView setBn_data:self.viewModel.recommends];
    [self.topicHeadView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getTopicsData];
    }];
    [self.viewModel.recommends.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.viewModel getTopicsData];
}

- (void)buildViewModel {
    
    [self buildSubjectViewModel];
}

#pragma mark - Header Or Foot UI
- (void)buildSubjectHeadView {
    if (!self.subjectHeadView) {
        self.subjectHeadView = [BN_ShopSpecialSubjectHeadView nib];
        [self.subjectHeadView collectionViewRegisterNib:[BN_ShopSpecialSubjectTipCell nib] forCellWithReuseIdentifier:ShopSpecialSubjectTipCellIdentifier];
    }
    
    [self.subjectHeadView updateWith:self.viewModel.specialDetail.coverImagesUrl comment:[NSString stringWithFormat:@"%d", self.viewModel.specialDetail.commentsNum] follow:[NSString stringWithFormat:@"%d", self.viewModel.specialDetail.collecteNum] like:[NSString stringWithFormat:@"%d", self.viewModel.specialDetail.likeNum] content:self.viewModel.specialDetail.content];
    [self.subjectHeadView updateWith:self.viewModel.dataSource];

}

- (void)buildTopicHeadView {
    self.topicHeadView = [BN_ShopSpecialTopicHeadView nib];
}

- (void)buildCommentHeadView {
    if (!self.commentHeadView) {
        self.commentHeadView = [BN_ShopSpecialCommentHeadView nib];
    }
    [self.commentHeadView updateWith:[self.viewModel collectedNumStr] follow:self.viewModel.isFollow];
    [self.commentHeadView updateWith:self.viewModel.collectedImgs];
    [self.commentHeadView clickedFollowAction:^(id sender) {
#warning  点击收藏的+号处理
    }];
}

- (void)buildCommentFootView {
    self.commentFootView = [BN_ShopSpecialCommentFootView nib];
    [self.commentFootView clickedCommentAction:^(id sender) {
#warning  点击评论里的评论按钮
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        @weakify(self);
        CGFloat height = [tableView fd_heightForCellWithIdentifier:ShopSpecialSubjectCellIdentifier configuration:^(id cell) {
            BN_ShopGoodSpecialModel *item = [self.viewModel.dataSource itemAtIndexPath:indexPath];
            [(BN_ShopSpecialSubjectCell *)cell updateWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row] title:item.titleDisplay subTitle:item.viceTitleDisplay content:[self.viewModel contentAttributed:item.contentDisplay] follow:[NSString stringWithFormat:@"%d",item.likeNum] price:[self.viewModel realAttributedPrice:item.real_price]];
            [(BN_ShopSpecialSubjectCell *)cell updateWith:item.imageUrl1 subImgUrl:item.imageUrl2 completed:^(id cell) {
                @strongify(self);
                NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
                if (indexpath) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }];
        }];
        return height;
        
    } else if (indexPath.section == 1) {
        @weakify(self);
        CGFloat height = [tableView fd_heightForCellWithIdentifier:ShopSpecialCommentCellIdentifier configuration:^(id cell) {
            @strongify(self);
            BN_ShopGoodSpecialCommentModel *item = [self.viewModel.dataSource itemAtIndexPath:indexPath];
            [(BN_ShopSpecialCommentCell *)cell updateWith:nil comentNum:[NSString stringWithFormat:@"%d",item.commentsNum] follow:NO];
            [(BN_ShopSpecialCommentCell *)cell updateWith:item.userPicUrl name:item.userName content:item.remark date:item.commentDate];
            [(BN_ShopSpecialCommentCell *)cell updateWith:item.pics];
        }];
        return height;
    } else if (indexPath.section == 2) {
        return 108.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self.subjectHeadView getViewHeight];
    } else if (section == 1) {
        return [self.commentHeadView getViewHeight];
    } else if (section == 2) {
        return [self.topicHeadView getViewHeight];
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [self.commentFootView getViewHeight];
    }
    return 0.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.subjectHeadView;
    } else if (section == 1) {
        return self.commentHeadView;
    } else if (section == 2) {
        return self.topicHeadView;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return self.commentFootView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -

@end
