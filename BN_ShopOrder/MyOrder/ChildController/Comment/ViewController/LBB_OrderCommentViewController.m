//
//  LBB_OrderCommentViewController.m
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import "LBB_OrderCommentViewController.h"
#import "LBB_OrderCommentSectionView.h"
#import "LBB_OrderCommentTagViewCell.h"
#import "LBB_OrderHeader.h"

@interface LBB_OrderCommentViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation LBB_OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册CollectionReusableView；
    self.baseViewType = eOrderType_WaitComment;
    self.collectionView.backgroundColor = ColorBackground;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.commentBtn.backgroundColor = [UIColor clearColor];
    [self.commentBtn setBackgroundImage:[UIImage createImageWithColor:ColorBtnYellow] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
    [self.commentBtn.titleLabel setFont:Font16];
}

- (void)buildControls
{
    self.ticketInfo = @{
                        @"ID" : @"1233",
                        @"TicketArray" : @[
                                @{
                                    TikcetIDKey : @"55wee",
                                    TikcetNameKey : @"鼓浪屿",
                                    TikcetImageKey : @"19.pic.jpg"
                                 },
                                @{
                                    TikcetIDKey : @"66wee",
                                    TikcetNameKey : @"中山街",
                                    TikcetImageKey : @"19.pic.jpg"
                                    },
                                ]
                        };
    [self initDataSourceArray];
    
    UINib *nib2 = [UINib nibWithNibName:@"LBB_OrderCommentSectionView" bundle:nil];
    [self.collectionView registerNib:nib2
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"LBB_OrderCommentSectionView"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellIdentifier"];
}

- (void)initDataSourceArray
{
    NSArray *ticketArray = [self.ticketInfo objectForKey:@"TicketArray"];
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:ticketArray.count];
    
    for (int i = 0; i < ticketArray.count; i++) {
        NSDictionary *ticketDict = [ticketArray objectAtIndex:i];
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [tmpDict setObject:[ticketDict objectForKey:TikcetIDKey] forKey:TikcetIDKey];
        [tmpDict setObject:[ticketDict objectForKey:TikcetNameKey] forKey:TikcetNameKey];
        [tmpDict setObject:[ticketDict objectForKey:TikcetImageKey] forKey:TikcetImageKey];
        //以下均为默认内容
        [tmpDict setObject:[NSNumber numberWithInteger:1] forKey:StarNumKey];
        [tmpDict setObject:@"此处是评论内容" forKey:CommentDescKey];
        if (i == 0) {
            [tmpDict setObject:@[
                                 @{
                                     DefaultKey : [NSNumber numberWithBool:NO],
                                     TicketTagDescKey:@"小萝莉"
                                     },
                                 @{
                                     DefaultKey : [NSNumber numberWithBool:YES],
                                     TicketTagDescKey:@"添加标签"
                                     }
                                 ] forKey:TagContentArrayKey];
        }else {
            [tmpDict setObject:@[
                                 @{
                                     DefaultKey : [NSNumber numberWithBool:YES],
                                     TicketTagDescKey:@"添加标签"
                                     }
                                 ] forKey:TagContentArrayKey];
        }
        
        [tmpDict setObject:@[
                             @{
                                 DefaultKey : [NSNumber numberWithBool:YES],
                                 PictureKey:[UIImage imageNamed:@"我的-添加.png"]
                                 }
                             ] forKey:PictureContentArrayKey];
        
        [self.dataSourceArray addObject:tmpDict];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public
- (void)resetDataSourceWithInfo:(NSDictionary*)info IsNeedReload:(BOOL)needReload
{
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NSMutableDictionary *dict = self.dataSourceArray[i];
        if ([[dict objectForKey:TikcetIDKey] isEqualToString:[info objectForKey:TikcetIDKey]]) {
            [self.dataSourceArray replaceObjectAtIndex:i withObject:info];
            if (needReload) {
                [self.collectionView reloadData];
            }
            break;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"UICollectionViewCellIdentifier";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
   
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusable = [[UICollectionReusableView alloc] init];
    if (kind == UICollectionElementKindSectionHeader) {
        LBB_OrderCommentSectionView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBB_OrderCommentSectionView" forIndexPath:indexPath];
            NSDictionary *userHeadInfo = [self.dataSourceArray objectAtIndex:indexPath.section];
        view.cellInfo = [NSMutableDictionary dictionaryWithDictionary:userHeadInfo];
        view.parentVC = self;
        reusable = view;
    }
    return reusable;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(1.f, 1.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,10,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize mainSize = [[UIScreen mainScreen] bounds].size;
    NSDictionary *sectionDict = [self.dataSourceArray objectAtIndex:section];
    NSArray *tagArray = [sectionDict objectForKey:TagContentArrayKey];
    CGFloat height = 185.f + 35.f;
    CGFloat tagWidth = 0.f;
    for (int i = 0; i < tagArray.count; i++) {
        NSDictionary *tagDictInfo = [tagArray objectAtIndex:i];
        NSString *tagContent = [tagDictInfo objectForKey:TicketTagDescKey];
        tagWidth += orderCommentTagCellWith(tagContent, YES) + 5.f;
        if (tagWidth > mainSize.width - 60.f) {
            height += 35.f;
            tagWidth = orderCommentTagCellWith(tagContent, YES);;
        }
    }
    NSArray *pictureArray = [sectionDict objectForKey:PictureContentArrayKey];
    int imageWidth = (mainSize.width - 60)/4;
    height += (pictureArray.count%4) ? ((pictureArray.count/4) + 1) * imageWidth : (pictureArray.count/4) * imageWidth;
    
    return CGSizeMake(mainSize.width,height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}


#pragma mark - 立即评论

- (IBAction)commentBtnClickAction:(id)sender {
    
}

@end
