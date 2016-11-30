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
#import "BN_ShopSpecialCommentHeadViewModel.h"
#import "BN_ShopSpecialSubjectHeadViewModel.h"
#import "BN_ShopSpecialTopicCellModel.h"
#import "BN_ShopSpecialSubjectCellModel.h"

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
@property (nonatomic, strong) BN_ShopSpecialCommentHeadViewModel *commentHeadViewModel;
@property (nonatomic, strong) BN_ShopSpecialSubjectHeadViewModel *subjectHeadViewModel;

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
        self.subjectHeadViewModel = [[BN_ShopSpecialSubjectHeadViewModel alloc] init];
        self.subjectHeadViewModel.specialId = specialId;
        
        self.viewModel = [[BN_ShopSpecialSubjectViewModel alloc] init];
        self.viewModel.specialId = specialId;
        
        self.commentHeadViewModel = [[BN_ShopSpecialCommentHeadViewModel alloc] init];
        self.commentHeadViewModel.specialId = specialId;
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
    commentSection.configureCellBlock = ^(id cell, BN_ShopGoodCommentsModel *item){
        [(BN_ShopSpecialCommentCell *)cell updateWith:nil comentNum:[NSString stringWithFormat:@"%d",item.commentsNum] follow:NO];
        [(BN_ShopSpecialCommentCell *)cell updateWith:item.userPicUrl name:item.userName content:item.remark date:item.commentDate];
        [(BN_ShopSpecialCommentCell *)cell updateWith:item.pics];
    };
    @weakify(self);
    SectionDataSource *specialsSection = [self.viewModel.dataSource sectionAtIndex:0];
    specialsSection.cellIdentifier = ShopSpecialSubjectCellIdentifier;
    specialsSection.configureCellBlock = ^(id cell, BN_ShopGoodSpecialModel *item){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [(BN_ShopSpecialSubjectCell *)cell updateWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row] title:item.title_display subTitle:item.vice_title_display content:[self.viewModel contentAttributed:item.content_display] follow:[NSString stringWithFormat:@"%d",item.total_like] price:[self.viewModel realAttributedPrice:item.real_price]];
        [(BN_ShopSpecialSubjectCell *)cell updateWith:item.pic_url subImgUrl:item.vice_pic_url completed:^(id cell) {
            @strongify(self);
            NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
            if (indexpath) {
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
        }];
        [(BN_ShopSpecialSubjectCell *)cell  clickedAction:^(id sender) {
#warning 点击购买做什么呢
        }];
    };
    
    SectionDataSource *tipsSection = [self.viewModel.dataSource sectionAtIndex:2];
    tipsSection.cellIdentifier = ShopSpecialTopicCellIdentifier;
    tipsSection.configureCellBlock = ^(id cell, BN_ShopSpecialTopicCellModel *item){
        [(BN_ShopSpecialTopicCell *)cell updateWith:item.imgUrl title:item.title subTitle:item.subTitle tip:item.tip];
    };
    
    [self.commentHeadView setBn_data:self.viewModel.comments];
    [self.commentHeadView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getCommentsClearData:YES];
    }];
    [self.viewModel.comments.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.commentHeadView updateWith:[self.commentHeadViewModel numStr] follow:self.viewModel.isFollow];
        [self.commentHeadView updateWith:self.commentHeadViewModel.imgUrls];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        //数据处理
        
    }];
    [self.viewModel getCommentsClearData:YES];
    
    [self.viewModel.specials.loadSupport setDataRefreshblock:^{
        //数据处理
    }];
    [self.viewModel getSpecialsData];
    
    [self.topicHeadView setBn_data:self.viewModel.topics];
    [self.topicHeadView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getTopicsData];
    }];
    [self.viewModel.topics.loadSupport setDataRefreshblock:^{
        @strongify(self);
        //数据处理
    }];
    
}

- (void)buildViewModel {
    
    
    self.commentHeadViewModel = [[BN_ShopSpecialCommentHeadViewModel alloc] init];
    self.commentHeadViewModel.num = @"89";
    

//    self.subjectHeadViewModel = [[BN_ShopSpecialSubjectHeadViewModel alloc] init];
//    self.subjectHeadViewModel.tips = @[@"芭蕾", @"就把", @"春来的会哭"];
//    self.subjectHeadViewModel.comment = @"9989898";
//    self.subjectHeadViewModel.follow = @"15";
//    self.subjectHeadViewModel.like = @"190";
//    self.subjectHeadViewModel.content = [testStr substringWithRange:NSMakeRange(random()%6, 70)];
//    self.subjectHeadViewModel.imgUrl = [testImgs objectAtIndex:random()%5];
    
    self.subjectHeadViewModel.dataSource = [[TableDataSource alloc] initWithItems:self.subjectHeadViewModel.tips cellIdentifier:ShopSpecialSubjectTipCellIdentifier configureCellBlock:^(id cell, id item) {
        [(BN_ShopSpecialSubjectTipCell *)cell updateWith:item];
    }];
    
    
    
    [self.tableView reloadData];
}

#pragma mark - Header Or Foot UI
- (void)buildSubjectHeadView {
    self.subjectHeadView = [BN_ShopSpecialSubjectHeadView nib];
    [self.subjectHeadView collectionViewRegisterNib:[BN_ShopSpecialSubjectTipCell nib] forCellWithReuseIdentifier:ShopSpecialSubjectTipCellIdentifier];
    
    [self.subjectHeadView updateWith:self.subjectHeadViewModel.detailModel.cover_img comment:self.subjectHeadViewModel.detailModel.total_comment follow:self.subjectHeadViewModel.detailModel.total_collected like:self.subjectHeadViewModel.detailModel.total_like content:self.subjectHeadViewModel.detailModel.content];
    [self.subjectHeadView updateWith:self.subjectHeadViewModel.dataSource];

}

- (void)buildTopicHeadView {
    self.topicHeadView = [BN_ShopSpecialTopicHeadView nib];
}

- (void)buildCommentHeadView {
    self.commentHeadView = [BN_ShopSpecialCommentHeadView nib];
    [self.commentHeadView updateWith:[self.commentHeadViewModel numStr] follow:self.viewModel.isFollow];
    [self.commentHeadView updateWith:self.commentHeadViewModel.imgUrls];
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
            BN_ShopSpecialSubjectCellModel *model = [self.viewModel.dataSource itemAtIndexPath:indexPath];
            [(BN_ShopSpecialSubjectCell *)cell updateWith:model.No title:model.title subTitle:model.subTitle content:[model contentAttributed] follow:[model followStr] price:[model priceAttributed]];
            [(BN_ShopSpecialSubjectCell *)cell updateWith:model.imgUrl subImgUrl:model.subImgUrl completed:^(id cell) {
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
            BN_ShopGoodCommentsModel *item = [self.viewModel.dataSource itemAtIndexPath:indexPath];
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
