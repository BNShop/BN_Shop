//
//  LBB_ApplyAalesViewController.m
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_ApplyAalesViewController.h"
#import "LBB_SaleafterModel.h"
#import "LBB_OrderAalesPictureViewCell.h"
#import "LBB_OrderAalesReusableHeadView.h"
#import "LBB_OrderAalesCollectionViewCell.h"
#import "LBB_OrderAalesDescViewCell.h"
#import "LBB_OrderImagePickerViewController.h"
#import "LBB_OrderAalesFooterReusableView.h"
#import "BN_ShopHeader.h"

#define RowKey  @"rows"
#define RowType  @"RowType"
#define SectionKey @"section"
#define SectionTipKey @"sectionTip"

#define HeadResuableIdentifier  @"LBB_OrderAalesReusableHeadView"
#define NormalCellIdentifier    @"LBB_OrderAalesCollectionViewCell"
#define PictureCellIdentifier   @"LBB_OrderAalesPictureViewCell"
#define DescViewCellIdentifier   @"LBB_OrderAalesDescViewCell"

@interface LBB_ApplyAalesViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) LBB_OrderImagePickerViewController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (strong,nonatomic) LBB_SaleafterTypeViewModel *viewModel;

@property(nonatomic,copy) NSString* typeContent;
@property(nonatomic,copy) NSString *reasonContent;
@property(nonatomic,copy) NSString *descContent;
@property(nonatomic,strong) NSMutableArray *picArray;

@end

@implementation LBB_ApplyAalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray* array = @[
                    @{ SectionKey : @"退款类型",
                          RowKey : @[@"我要退款",@"我要退货"],
                          RowType :@(1)
                           },
                       @{ SectionKey : @"退款原因",
                          RowKey : @[@"请选择退款原因"],
                          RowType :@(1)
                          },
                       @{ SectionKey : @"退款说明",
                          SectionTipKey : @"（可不填）",
                          RowKey : @[@"请输入退款说明"],
                          RowType :@(1)
                          },
                       @{ SectionKey : @"上传图片",
                          RowKey : @[[UIImage imageNamed:@"我的-添加.png"]],
                          RowType :@(2)
                          }];
    
    self.dataSourceArray = [[NSMutableArray alloc] initWithArray:array];
}

- (void)buildControls
{
    UINib *nib1 = [UINib nibWithNibName:@"LBB_OrderAalesCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:NormalCellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"LBB_OrderAalesPictureViewCell" bundle:nil];
    [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:PictureCellIdentifier];
    
    UINib *nib3 = [UINib nibWithNibName:@"LBB_OrderAalesDescViewCell" bundle:nil];
    [self.collectionView registerNib:nib3 forCellWithReuseIdentifier:DescViewCellIdentifier];
    
    UINib *nib4 = [UINib nibWithNibName:@"LBB_OrderAalesReusableHeadView" bundle:nil];
    [self.collectionView registerNib:nib4
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:HeadResuableIdentifier];
    
    UINib *nib5 = [UINib nibWithNibName:@"LBB_OrderAalesFooterReusableView" bundle:nil];
    [self.collectionView registerNib:nib5
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:@"LBB_OrderAalesFooterReusableView"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfRows:(NSInteger)section
{
    if (section < self.dataSourceArray.count) {
        NSDictionary *sectionDict = [self.dataSourceArray objectAtIndex:section];
        NSArray *rowsArray = [sectionDict objectForKey:RowKey];
        if (section == (self.dataSourceArray.count - 1)) {
            NSInteger count =  self.picArray.count;
            if (count >= 3) {
                return 3;
            }
            return 1 + self.picArray.count;

        }else {
            return [rowsArray count];
        }
     }

    return 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return CGSizeMake(DeviceWidth, 44.f);
    }else if(indexPath.section == 2) {
        return CGSizeMake(DeviceWidth, 150.f);
    }else if(indexPath.section == 3){
        CGSize mainSize = [[UIScreen mainScreen] bounds].size;
        return CGSizeMake((mainSize.width - 30)/4.0,((mainSize.width - 30)/4.0 + 25));
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == (self.dataSourceArray.count - 1)) {
        return UIEdgeInsetsMake(5,10,5,10);
    }
    return UIEdgeInsetsMake(0,0,5,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == self.dataSourceArray.count - 1) {
        return CGSizeMake(DeviceWidth, 0.1f);
    }
    return CGSizeMake(DeviceWidth, 44.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2) {
         return CGSizeMake(DeviceWidth, 10.f);
    }
   return CGSizeMake(DeviceWidth, 0.1f);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return [self numberOfRows:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = NormalCellIdentifier;
    static NSString *CellIdentifier2 = DescViewCellIdentifier;
    static NSString *CellIdentifier3 = PictureCellIdentifier;
    
    UICollectionViewCell *resultCell = [[UICollectionViewCell alloc] init];
    
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.section];
    if (indexPath.section == 0 || indexPath.section == 1) {//退款类型、退款原因
        LBB_OrderAalesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];
        
        NSArray *rowsArray = [dict objectForKey:RowKey];
        cell.textLabel.text = rowsArray[indexPath.row];
        cell.rightImgView.hidden = YES;
        cell.textLabel.textColor = ColorBlack;
        if (indexPath.section == 0) {
            if ([cell.textLabel.text isEqualToString:self.typeContent]) {
                cell.rightImgView.hidden = NO;
                cell.textLabel.textColor = ColorRed;
            }
        }else {
            if ([self.reasonContent length]) {
                cell.textLabel.text = self.reasonContent;
                cell.rightImgView.hidden = NO;
            }
        }
        resultCell = cell;
    }else if(indexPath.section == 2){//退款说明
        LBB_OrderAalesDescViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2 forIndexPath:indexPath];
        cell.textView.delegate = self;
        if ([self.descContent length]) {
            cell.textView.text = self.descContent;
        }else {
            cell.textView.text = nil;
            cell.textView.placeholder = @"输入退款说明";
        }
        resultCell = cell;
    }else if(indexPath.section == 3){//图片
        LBB_OrderAalesPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier3 forIndexPath:indexPath];
        NSLog(@" indexPath.row = %ld,%ld",indexPath.row,(self.picArray.count - 1));
        NSInteger picCount = self.picArray.count;
        if (indexPath.row < picCount) {
            cell.imageView.image = self.picArray[indexPath.row];
            cell.addImgView.image = nil;
        }else {
            NSArray *rowsArray = [dict objectForKey:RowKey];
            cell.addImgView.image = rowsArray[0];
            cell.imageView.image = nil;
            cell.tipLabel.text = @"上传凭证最多3张";
        }
        
        resultCell = cell;

    }
    
    return resultCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusable = [[UICollectionReusableView alloc] init];
    if (kind == UICollectionElementKindSectionHeader) {
        LBB_OrderAalesReusableHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadResuableIdentifier forIndexPath:indexPath];
        if (indexPath.section < self.dataSourceArray.count) {
            NSDictionary *sectionDict = self.dataSourceArray[indexPath.section];
            view.textLabel.text = [sectionDict objectForKey:SectionKey];
            if (indexPath.section == (self.dataSourceArray.count - 1)) {
                view.textLabel.text = nil;
            }
        }
        reusable = view;
    }else if(kind == UICollectionElementKindSectionFooter){
        LBB_OrderAalesFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LBB_OrderAalesFooterReusableView" forIndexPath:indexPath];
        reusable = view;
    }
    return reusable;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏键盘
    [self.view endEditing:YES];
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        NSArray *rowsArray = [dict objectForKey:RowKey];
        if (indexPath.row < rowsArray.count) {
            self.typeContent = rowsArray[indexPath.row];
        }
        [self.collectionView reloadData];
    }else if(indexPath.section == 3){
        NSArray *pictureArray = self.picArray;
        if (indexPath.row == pictureArray.count && ([self.picArray count] < 3)) {
            [self showImagePickerMenu];
        }else {
            [self removePictureAlert:indexPath.row];
        }
    }
}

#pragma mark - 增加评论图片
- (void)showImagePickerMenu
{
    NSString *cameraStr = NSLocalizedString(@"相机", nil);
    NSString *albumStr = NSLocalizedString(@"相册", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换封面图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *camraAction = [UIAlertAction actionWithTitle:cameraStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:albumStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showImagePickerView:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    
    // Add the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    // Add the actions.
    [alertController addAction:camraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker = nil;
    
    self.imagePicker = [[LBB_OrderImagePickerViewController alloc] initPickerWithType:sourceType
                                                                               Parent:self];
    
    __weak typeof (self) weakSelf = self;
    [self.imagePicker showPicker:^(UIImage *resultImage){
        NSLog(@"%d",resultImage == nil);
        [weakSelf addImageComment:resultImage];
    }];
}

- (void)addImageComment:(UIImage*)image
{
    if (image) {
        if (!self.picArray) {
            self.picArray = [[NSMutableArray alloc] init];
        }
        [self.picArray addObject:image];
        [self.collectionView reloadData];
    }
}

#pragma mark - 删除评论图片
- (void)removePictureAlert:(NSInteger)removeIndex
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除图片"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action){
                               [self removePicture:removeIndex];
                               
                           }];
    
    UIAlertAction *cancel =
    [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action){
                           }];
    
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)removePicture:(NSInteger)removeIndex
{
    BOOL isRemove = NO;
    NSMutableArray *pictureArray = self.picArray;
    if ([pictureArray count] > removeIndex) {
        [pictureArray removeObjectAtIndex:removeIndex];
        isRemove = YES;
    }
    if (isRemove) {
        [self.collectionView reloadData];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.descContent = [self.descContent Trim];
    if ([self.descContent length]) {
        [self.collectionView reloadData];
    }
}


- (IBAction)bottomBtnClickAction:(id)sender
{
    
}

@end
