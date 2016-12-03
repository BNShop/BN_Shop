//
//  BN_ShopGoodSpecificDetailsViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodSpecificDetailsViewController.h"
#import "PureLayout.h"

@interface BN_ShopGoodSpecificDetailsViewController ()

@property (nonatomic, strong) UIWebView *webss;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView* webBrowserView;

@property (nonatomic, copy) NSString *html;

@end

@implementation BN_ShopGoodSpecificDetailsViewController

- (instancetype)initWithHtml:(NSString *)html {
    if (self = [super init]) {
        self.html = html;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForWebViewContentSize];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserverForWebViewContentSize];
}

- (void)buildControls {
    [super buildControls];
    
    [self buildWebView];

}

#pragma mark -
- (void)addObserverForWebViewContentSize
{
    [self.webss.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObserverForWebViewContentSize
{
    [self.webss.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self setBuildFooterView];
}

- (NSString *)htmls {
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",_html];
    return htmls;
}

- (void)buildWebView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerHight)];
    }
    
    self.webss = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webss.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.webss loadHTMLString:[self htmls] baseURL:nil];
    self.webss.backgroundColor = [UIColor whiteColor];
    self.webss.opaque = NO;
    self.webss.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.webss.scalesPageToFit = YES;
    if ([self.webss.subviews count] > 0)
    {
        UIScrollView  *scroller = [self.webss.subviews objectAtIndex:0];
        if (scroller)
        {
            for (UIView *v in [scroller subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                    [v removeFromSuperview];
            }
        }
    }
    
    self.webBrowserView = self.webss.scrollView.subviews[0];
    CGRect frame = self.webBrowserView.frame;
    frame.origin.y = _headerHight;
    self.webBrowserView.frame = frame;
    [self addObserverForWebViewContentSize];
    [self setBuildWebHead];
    [self.view addSubview:_webss];
    
}

- (void)setBuildWebHead {
    [self.webss.scrollView addSubview:_headView];
}

//设置footerView，并计算合适位置；
- (void)setBuildFooterView {
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    [_footerView removeFromSuperview];
    
    CGSize contentSize = self.webss.scrollView.contentSize;
    
    _footerView.userInteractionEnabled = YES;
    _footerView.frame = CGRectMake(0, contentSize.height, contentSize.width, self.footerHight);
    
    [self.webss.scrollView addSubview:_footerView];
    self.webss.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + self.footerHight);
    
    //重新监听
    [self addObserverForWebViewContentSize];
}

#pragma mark - set headView
- (void)setFooterView:(UIView *)footerView {
    self.footerHight += 60;
    if (!_footerView) {
        CGSize contentSize = self.webss.scrollView.contentSize;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, contentSize.height, WIDTH(self.view), self.footerHight)];
        [self.webss.scrollView addSubview:_footerView];
        self.webss.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + self.footerHight);
    }
    if (footerView) {
        CGRect rect = CGRectMake(0, 0, WIDTH(_footerView), 192);
        footerView.frame = rect;
        [footerView sizeToFit];
        [_footerView addSubview:footerView];
    }
    
}


- (void)setHeadView:(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerHight)];
    }
    if (headView) {
        CGRect rect = headView.frame;
        rect.origin.y = 0;
        rect.size.height = self.headerHight;
        headView.frame = rect;
        [_headView addSubview:headView];
    }
}

- (CGPoint)contentOffset {
    return self.webss.scrollView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.webss.scrollView.contentOffset = contentOffset;
}

@end
