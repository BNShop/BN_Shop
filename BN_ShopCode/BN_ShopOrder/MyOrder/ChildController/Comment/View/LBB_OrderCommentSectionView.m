//
//  LBB_OrderCommentSectionView.m
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import "LBB_OrderCommentSectionView.h"
#import "LBB_OrderCommentTagViewCell.h"
#import "LBB_OrderCommentPicturViewCell.h"
#import "LBB_OrderCommentViewController.h"
#import "LBB_OrderImagePickerViewController.h"
#import "LBB_OrderImagePickerViewController.h"
#import "LBB_OrderHeader.h"

@interface LBB_OrderCommentSectionView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UITextViewDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (assign,nonatomic) NSInteger starNum;//好评星星数量
@property (copy, nonatomic) NSString *tagComment;//新增编辑标签
@property (strong,nonatomic) UIImage *commentImage;//新增评论图片
@property (strong,nonatomic) NSString *textCotent;//文本评论内容
@property (strong,nonatomic) LBB_OrderImagePickerViewController *imagePicker;
@end

@implementation LBB_OrderCommentSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exclusiveTouch = YES;
    self.textView.delegate = self;
    //进行CollectionView和Cell的绑定
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.backgroundColor = ColorWhite;
    self.textView.backgroundColor = ColorWhite;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = ColorLine.CGColor;
    
    UINib *nib1 = [UINib nibWithNibName:@"LBB_OrderCommentPicturViewCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:@"LBB_OrderCommentPicturViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:@"LBB_OrderCommentTagViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"LBB_OrderCommentTagViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    for (int i = 1; i <= 5; i++) {
        UIButton *starBtn = [self.starBgView viewWithTag:i];
        if (starBtn) {
            starBtn.exclusiveTouch = YES;
        }
    }
    self.iconImgView.backgroundColor = ColorLine;
    self.textView.placeholder =@"请输入评论内容";
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _cellInfo = nil;
    [self.collectionView reloadData];
}
- (void)setCellInfo:(NSMutableDictionary *)cellInfo
{
    @weakify(self);
    
    [self.textView.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.textCotent = self.textView.text;
    }];
    
    _cellInfo = cellInfo;
    NSString *ticketImageURL = [_cellInfo objectForKey:TikcetImageKey];
    if ([ticketImageURL length]) {
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ticketImageURL] placeholderImage:nil];
    }else{
        self.iconImgView.image = nil;
    }
     
    self.nameLabel.text = [_cellInfo objectForKey:TikcetNameKey];
    NSInteger starNum = [[_cellInfo objectForKey:StarNumKey] integerValue];
    //好评星星数量
    UIButton *starBtn = [self.starBgView viewWithTag:starNum];
    if (starNum) {
        starBtn.selected = NO;
        [self starBtnClickAction:starBtn];
    }
 
    //评论内容
    NSString *textContent = [_cellInfo objectForKey:CommentDescKey];
    self.textView.text = textContent;
    
    [self.collectionView reloadData];
}

- (IBAction)starBtnClickAction:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    for (int i = 1; i <= 5; i++) {
        UIButton *starBtn = [self.starBgView viewWithTag:i];
        if (starBtn.tag <= btn.tag) {
            if (btn.selected) {
               starBtn.selected = btn.selected;
            }else {
                if (starBtn.tag < btn.tag) {
                    starBtn.selected = YES;
                }
            }
        }else {
            starBtn.selected = NO;
        }
    }
    if (btn.selected) {
        self.starNum = btn.tag;
    }else {
        self.starNum = btn.tag - 1;
    }
    [self.cellInfo setObject:[NSNumber numberWithInteger:self.starNum] forKey:StarNumKey];
    [self resetParentVCDataSource:NO];
    NSLog(@"\n 好评 %@ 颗星",@(self.starNum));
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *tagArray = [self.cellInfo objectForKey:TagContentArrayKey];
        return tagArray.count;
    }else if(section == 1){
        NSArray *pictureArray = [self.cellInfo objectForKey:PictureContentArrayKey];
        return pictureArray.count;
    }
    
    return 0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"LBB_OrderCommentTagViewCell";
    static NSString *CellIdentifier2 = @"LBB_OrderCommentPicturViewCell";
    
    UICollectionViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        LBB_OrderCommentTagViewCell *tagCells =  (LBB_OrderCommentTagViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath]; 
        cell = tagCells;
        NSArray *tagArray = [self.cellInfo objectForKey:TagContentArrayKey];
        NSDictionary *tagDictInfo = [tagArray objectAtIndex:indexPath.row];
        tagCells.cellInfo = tagDictInfo;
        
    }else if(indexPath.section == 1){
        LBB_OrderCommentPicturViewCell *pictureCell =  (LBB_OrderCommentPicturViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2 forIndexPath:indexPath];
        cell = pictureCell;
        NSArray *pictureArray = [self.cellInfo objectForKey:PictureContentArrayKey];
        pictureCell.cellInfo = [pictureArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

                                              
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏键盘
   [self endEditing:YES];
    if (indexPath.section == 0) {
        NSArray *tagArray = [self.cellInfo objectForKey:TagContentArrayKey];
        NSDictionary *tagDictInfo = [tagArray objectAtIndex:indexPath.row];
        if ([[tagDictInfo objectForKey:DefaultKey] boolValue]) {
           [self showTagCommentEditView];
        }else {
            [self showRemoveTagCommentAlert:indexPath.row];
        }

    }else {
        NSArray *pictureArray = [self.cellInfo objectForKey:PictureContentArrayKey];
        NSDictionary *pictureInfo = [pictureArray objectAtIndex:indexPath.row];
        if ([[pictureInfo objectForKey:DefaultKey] boolValue]) {
            [self showImagePickerMenu];
        }else {
            [self removePictureAlert:indexPath.row];
        }
    }
}

#pragma mark - 增加 标签内容
- (void)showTagCommentEditView
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入标签内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        
        @weakify(self);
        [textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.tagComment = textField.text;
        }];
    }];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action){
                               self.tagComment = [self removeWhiteSpaceWithOrignString:self.tagComment];
                               [self addTagComment:self.tagComment];
                               self.tagComment = nil;
                           }];
    
    UIAlertAction *cancel =
    [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action){
                               self.tagComment = nil;
                           }];
    
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    
    [self.parentVC presentViewController:alertVC animated:YES completion:nil];
}

- (void)addTagComment:(NSString*)desc
{
    if (desc) {
        BOOL isExit = NO;
        NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[self.cellInfo objectForKey:TagContentArrayKey]];
        for (int i = 0; i < tagArray.count; i++) {
            NSDictionary *tagCellInfo = [tagArray objectAtIndex:i];
            if ([[tagCellInfo objectForKey:TicketTagDescKey] isEqualToString:desc]) {
                isExit = YES;
                break;
            }
        }
        if (!isExit) {
            NSInteger inserIndex = tagArray.count - 1;
            if (inserIndex < 0) {
                inserIndex = 0;
            }
            NSDictionary *addNewInfo = @{DefaultKey : [NSNumber numberWithBool:NO],
                                         TicketTagDescKey:desc};
            [tagArray insertObject:addNewInfo atIndex:inserIndex];
            [self.cellInfo setObject:tagArray forKey:TagContentArrayKey];
            [self resetParentVCDataSource:YES];
           
        }else{
            [(LBB_OrderCommentViewController*)self.parentVC  showHudPrompt:@"此标签内容重复哦"];
        }
    }
}

#pragma mark - 删除标签
- (void)showRemoveTagCommentAlert:(NSInteger)removeIndex
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除标签"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action){
                               [self removeTagComment:removeIndex];
                               
                           }];
    
    UIAlertAction *cancel =
    [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action){
                           }];
    
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    
    [self.parentVC presentViewController:alertVC animated:YES completion:nil];
 
}

- (void)removeTagComment:(NSInteger)removeIndex
{
    BOOL isRemove = NO;
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[self.cellInfo objectForKey:TagContentArrayKey]];
    if (tagArray.count > removeIndex) {
        [tagArray removeObjectAtIndex:removeIndex];
        isRemove = YES;
    }
    if (isRemove) {
        [self.cellInfo setObject:tagArray forKey:TagContentArrayKey];
        [self resetParentVCDataSource:YES];
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
    
    [self.parentVC presentViewController:alertController animated:YES completion:nil];
}

- (void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker = nil;
    
    self.imagePicker = [[LBB_OrderImagePickerViewController alloc] initPickerWithType:sourceType
                                                                          Parent:self.parentVC];
    
    __weak typeof (self) weakSelf = self;
    [self.imagePicker showPicker:^(UIImage *resultImage){
        NSLog(@"%d",resultImage == nil);
        [weakSelf addImageComment:resultImage];
    }];
}

- (void)addImageComment:(UIImage*)image
{
    if (image) {
        NSMutableArray *pictureArray = [NSMutableArray arrayWithArray:[self.cellInfo objectForKey:PictureContentArrayKey]];
        NSInteger inserIndex = pictureArray.count - 1;
        if (inserIndex < 0) {
            inserIndex = 0;
        }
        NSDictionary *addNewInfo = @{DefaultKey : [NSNumber numberWithBool:NO],
                                     PictureKey : image};
        [pictureArray insertObject:addNewInfo atIndex:inserIndex];
        
        [self.cellInfo setObject:pictureArray forKey:PictureContentArrayKey];
        [self resetParentVCDataSource:YES];
       
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
    
    [self.parentVC presentViewController:alertVC animated:YES completion:nil];
}

- (void)removePicture:(NSInteger)removeIndex
{
    BOOL isRemove = NO;
    NSMutableArray *pictureArray = [NSMutableArray arrayWithArray:[self.cellInfo objectForKey:PictureContentArrayKey]];
    if ([pictureArray count] > removeIndex) {
        [pictureArray removeObjectAtIndex:removeIndex];
        isRemove = YES;
    }
    if (isRemove) {
        [self.cellInfo setObject:pictureArray forKey:PictureContentArrayKey];
        [self resetParentVCDataSource:YES];
    }
}

#pragma mark -重新加载整个界面数据

- (void)resetParentVCDataSource:(BOOL)needReload
{
//    self.parentVC.view.userInteractionEnabled = NO;
    [(LBB_OrderCommentViewController*)self.parentVC resetDataSourceWithInfo:self.cellInfo
                                                                IsNeedReload:needReload];
//    self.parentVC.view.userInteractionEnabled = YES;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       NSArray *tagArray = [self.cellInfo objectForKey:TagContentArrayKey];
        NSDictionary *tagCellInfo = [tagArray objectAtIndex:indexPath.row];
        NSString *tagContent = [tagCellInfo objectForKey:TicketTagDescKey];
        CGFloat cellWidth = orderCommentTagCellWith(tagContent,YES);
        return CGSizeMake(cellWidth, 35.f);
    }else if(indexPath.section == 1) {
       CGSize mainSize = [[UIScreen mainScreen] bounds].size;
       return CGSizeMake((mainSize.width - 66)/4.0,(mainSize.width - 66)/4.0);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
  
  return UIEdgeInsetsMake(0,0,5,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
   return 1.f;
}

#pragma mark - 去除字符串首尾空白和换行
- (NSString*)removeWhiteSpaceWithOrignString:(NSString *)orignStr
{
    if (orignStr) {
        //去掉前后空格和换行
        NSString *newStr = [orignStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([newStr length] == 0) {
            return nil;
        }
        return newStr;
    }
    return nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textCotent = [self.textCotent Trim];
    if ([self.textCotent length]) {
        [self.cellInfo setObject:self.textCotent forKey:CommentDescKey];
        [self resetParentVCDataSource:NO];
    }
}

@end
