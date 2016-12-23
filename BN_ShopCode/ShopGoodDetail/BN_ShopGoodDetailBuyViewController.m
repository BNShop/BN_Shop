//
//  BN_ShopGoodDetailBuyViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailBuyViewController.h"
#import "BGButton.h"
#import "PKYStepper.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailBuyViewController ()



@property (weak, nonatomic) IBOutlet BGButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *numTipLabel;
@property (weak, nonatomic) IBOutlet PKYStepper *stepper;
@property (weak, nonatomic) IBOutlet UIView *midLineView;
@property (weak, nonatomic) IBOutlet UILabel *goodDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodDetailContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTipLabel1;

@property (assign, nonatomic) int count;


@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *standards;
@property (copy, nonatomic) NSString *price;
@end

@implementation BN_ShopGoodDetailBuyViewController

- (instancetype)initWith:(NSString *)iconUrl standards:(NSString *)standards price:(NSString *)price
{
    self = [super init];
    if (self) {
        self.iconUrl = iconUrl;
        self.standards = standards;
        self.price = price;
    }
    return self;
}

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
    self.count = 1;
    self.midLineView.backgroundColor = ColorLine;
    
    self.iconImageView.q_BorderColor = ColorLine;
    self.iconImageView.q_BorderWidth = 1.0f;
    [self.iconImageView sd_setImageWithURL:[self.iconUrl URL]];
    
    self.numTipLabel.text = TEXT(@"选择数量");
    self.numTipLabel.font = Font12;
    self.numTipLabel.textColor = ColorBlack;
    
    self.goodDetailLabel.text = TEXT(@"商品规格");
    self.goodDetailLabel.font = Font12;
    self.goodDetailLabel.textColor = ColorBlack;
    
    self.goodDetailContentLabel.text = self.standards;
    self.goodDetailContentLabel.font = Font10;
    self.goodDetailContentLabel.textColor = ColorLightGray;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.price];
    self.priceLabel.font = Font12;
    self.priceLabel.textColor = ColorBtnYellow;
    
    self.numTipLabel1.text = TEXT(@"请选择商品数量");
    self.numTipLabel1.font = Font10;
    self.numTipLabel1.textColor = ColorLightGray;
    
    self.okButton.normalColor = ColorBtnYellow;
    [self.okButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.okButton.titleLabel.font = Font13;
    [self.okButton setTitle:@"确  认" forState:UIControlStateNormal];
    
    @weakify(self)
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        @strongify(self);
        [self valueChanged:count];
    };
    self.stepper.value = self.count;
    self.stepper.minimum = 1;
    [self.stepper setLabelTextColor:[UIColor blackColor]];
    [self.stepper setLabelFont:Font10];
    [self.stepper setButtonWidth:40.0f];
    [self.stepper setButtonTextColor:ColorLightGray forState:UIControlStateNormal];
    [self.stepper setButtonFont:Font14];
    [self.stepper setBorderColor:ColorLightGray];
    [self.stepper setup];
}

- (void)valueChanged:(float)count {
    self.count = count;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goodDetailBuyCountWith:goodId:)]) {
        [self.delegate goodDetailBuyCountWith:self.count goodId:self.goodId];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
