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
#import "BN_ShopSpecialCommentCellModel.h"
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

#import "TestObjectHeader.h"



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
- (void)buildViewModel {
    self.viewModel = [[BN_ShopSpecialSubjectViewModel alloc] init];
    self.viewModel.isFollow = random()%2;
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        BN_ShopSpecialSubjectCellModel *model = [[BN_ShopSpecialSubjectCellModel alloc] init];
        model.No = [NSString stringWithFormat:@"%ld", (long)i];
        model.title = @"白板南中的店";
        model.subTitle = @"水珠麻将牌";
        model.contentHtml = [testStr substringWithRange:NSMakeRange(random()%5, 120)];;
        model.imgUrl = [testImgs objectAtIndex:random()%6];
        model.subImgUrl = [testImgs objectAtIndex:random()%6+1];
        model.follow = @"60";
        model.price = @"540";
        [array addObject:model];
    }
    
    SectionDataSource *section0 = [[SectionDataSource alloc] initWithItems:array title:nil];
    section0.cellIdentifier = ShopSpecialSubjectCellIdentifier;
    @weakify(self);
    section0.configureCellBlock = ^(id cell, id item){
        @strongify(self);
        BN_ShopSpecialSubjectCellModel *model = (BN_ShopSpecialSubjectCellModel *)item;
        [(BN_ShopSpecialSubjectCell *)cell updateWith:model.No title:model.title subTitle:model.subTitle content:[model contentAttributed] follow:[model followStr] price:[model priceAttributed]];
        [(BN_ShopSpecialSubjectCell *)cell updateWith:model.imgUrl subImgUrl:model.subImgUrl completed:^(id cell) {
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
    
    array = [NSMutableArray array];
    
    for (NSInteger i=0; i<1; i++) {
        BN_ShopSpecialCommentCellModel *model = [[BN_ShopSpecialCommentCellModel alloc] init];
        model.iconUrl = @"http://img55.yeds.net/FileSource3/a8f24e78-b8ee-4d92-8273-d12428c2d41c.jpg";
        model.name = @"九九归一表格";
        model.content = [testStr substringWithRange:NSMakeRange(random()%10, 90)];
        model.date = @"2016-11-27";
        model.follow = @"80";
        model.coment = @"134";
        model.isFollow = random() % 2;
        model.imgUrls = [testImgs subarrayWithRange:NSMakeRange(random()%3, random()%3)];
        [array addObject:model];
    }
    SectionDataSource *section1 = [[SectionDataSource alloc] initWithItems:array title:nil];
    section1.cellIdentifier = ShopSpecialCommentCellIdentifier;
    section1.configureCellBlock = ^(id cell, id item){
        BN_ShopSpecialCommentCellModel *model = (BN_ShopSpecialCommentCellModel *)item;
        [(BN_ShopSpecialCommentCell *)cell updateWith:model.follow comentNum:model.coment follow:model.isFollow];
        [(BN_ShopSpecialCommentCell *)cell updateWith:model.iconUrl name:model.name content:model.content date:model.date];
        [(BN_ShopSpecialCommentCell *)cell updateWith:model.imgUrls];
    };
    
    array = [NSMutableArray array];
    for (NSInteger i=0; i<2; i++) {
        BN_ShopSpecialTopicCellModel *model = [[BN_ShopSpecialTopicCellModel alloc] init];
        model.imgUrl = [testImgs objectAtIndex:random()%6];
        model.title = @"生命的意义";
        model.subTitle = @"睡觉哦范围 魔都佛 就放辣椒";
        model.tip = @"奇偶发呕佛";
        [array addObject:model];
    }
    SectionDataSource *section2 = [[SectionDataSource alloc] initWithItems:array title:nil];
    section2.cellIdentifier = ShopSpecialTopicCellIdentifier;
    section2.configureCellBlock = ^(id cell, id item){
        BN_ShopSpecialTopicCellModel *model = (BN_ShopSpecialTopicCellModel *)item;
        [(BN_ShopSpecialTopicCell *)cell updateWith:model.imgUrl title:model.title subTitle:model.subTitle tip:model.tip];
    };
    [self.viewModel addDataSourceWith:section0];
    [self.viewModel addDataSourceWith:section1];
    [self.viewModel addDataSourceWith:section2];
    self.tableView.dataSource = self.viewModel.dataSource;
    
    
    
    self.commentHeadViewModel = [[BN_ShopSpecialCommentHeadViewModel alloc] init];
    self.commentHeadViewModel.num = @"89";
    self.commentHeadViewModel.imgUrls = [testImgs subarrayWithRange:NSMakeRange(0, 6)];
    

    self.subjectHeadViewModel = [[BN_ShopSpecialSubjectHeadViewModel alloc] init];
    self.subjectHeadViewModel.tips = @[@"芭蕾", @"就把", @"春来的会哭"];
    self.subjectHeadViewModel.comment = @"9989898";
    self.subjectHeadViewModel.follow = @"15";
    self.subjectHeadViewModel.like = @"190";
    self.subjectHeadViewModel.content = [testStr substringWithRange:NSMakeRange(random()%6, 70)];
    self.subjectHeadViewModel.imgUrl = [testImgs objectAtIndex:random()%5];
    
    self.subjectHeadViewModel.dataSource = [[TableDataSource alloc] initWithItems:self.subjectHeadViewModel.tips cellIdentifier:ShopSpecialSubjectTipCellIdentifier configureCellBlock:^(id cell, id item) {
        [(BN_ShopSpecialSubjectTipCell *)cell updateWith:item];
    }];
    
    [self buildTopicHeadView];
    [self buildCommentFootView];
    [self buildCommentHeadView];
    [self buildSubjectHeadView];
    
    [self.tableView reloadData];
}

#pragma mark - Header Or Foot UI
- (void)buildSubjectHeadView {
    self.subjectHeadView = [BN_ShopSpecialSubjectHeadView nib];
    [self.subjectHeadView collectionViewRegisterNib:[BN_ShopSpecialSubjectTipCell nib] forCellWithReuseIdentifier:ShopSpecialSubjectTipCellIdentifier];
    
    [self.subjectHeadView updateWith:self.subjectHeadViewModel.imgUrl comment:self.subjectHeadViewModel.comment follow:self.subjectHeadViewModel.follow like:self.subjectHeadViewModel.like content:self.subjectHeadViewModel.content];
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
            BN_ShopSpecialCommentCellModel *model = [self.viewModel.dataSource itemAtIndexPath:indexPath];
            [(BN_ShopSpecialCommentCell *)cell updateWith:model.iconUrl name:model.name content:model.content date:model.date];
            [(BN_ShopSpecialCommentCell *)cell updateWith:model.follow comentNum:model.coment follow:model.isFollow];
            [(BN_ShopSpecialCommentCell *)cell updateWith:model.imgUrls];
            
            
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
