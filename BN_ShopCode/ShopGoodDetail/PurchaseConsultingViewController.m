//
//  PurchaseConsultingViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "PurchaseConsultingViewController.h"
#import "UITextView+Placeholder.h"
#import "BGButton.h"

@interface PurchaseConsultingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tooltipLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet BGButton *submitButton;

@end

@implementation PurchaseConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [super buildControls];
    self.title = TEXT(@"发表咨询");
    
    self.tooltipLabel.text = TEXT(@"咨询内容");
    self.tooltipLabel.font = Font12;
    self.tooltipLabel.textColor = ColorBlack;
    
    self.contentsTextView.text = nil;
    self.contentsTextView.font = Font12;
    self.contentsTextView.textColor = ColorBlack;
    self.contentsTextView.placeholder = TEXT(@"请输入您的问题");
    self.contentsTextView.placeholderColor = ColorLightGray;
    self.contentsTextView.q_BorderWidth = 1.5f;
    self.contentsTextView.q_BorderColor = ColorLine;
    
    self.submitButton.normalColor = ColorBtnYellow;
    self.submitButton.titleLabel.font = Font15;
    [self.submitButton setTitleColor:ColorWhite forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitAction:(id)sender {
    if (self.contentsTextView.text) {
#warning - 发送资讯请求
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
