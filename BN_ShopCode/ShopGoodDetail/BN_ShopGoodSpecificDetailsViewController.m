//
//  BN_ShopGoodSpecificDetailsViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodSpecificDetailsViewController.h"
#import <CoreText/CoreText.h>
#import <DTCoreText/DTCoreText.h>

@interface BN_ShopGoodSpecificDetailsViewController ()<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) DTAttributedTextView *textView;


@property (nonatomic, strong) UIWebView *webss;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footerView;

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
    
    // Create text view
//    self.textView = [[DTAttributedTextView alloc] initWithFrame:self.view.bounds];
//    
//    // we draw images and links via subviews provided by delegate methods
//    self.textView.shouldDrawImages = NO;
//    self.textView.shouldDrawLinks = NO;
//    self.textView.textDelegate = self; // delegate for custom sub views
//    
//    // gesture for testing cursor positions
//    //	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    //	[_textView addGestureRecognizer:tap];
//    
//    // set an inset. Since the bottom is below a toolbar inset by 44px
//    [self.textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
//    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);
//    
//    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.textView];
//
//    
//    self.textView.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO];
//    [self performSelector:@selector(setHeadView:) withObject:self.headView afterDelay:0.005f];
    
    [self buildWebView];
    
    
}


- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes
{
    NSData *data = [self.html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    
    if (useiOS6Attributes)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:DTUseiOS6Attributes];
    }
    
//    [options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

#pragma mark - DTAttributedTextContentViewDelegate

//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
//{
//	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
//
//	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
//	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
//
//
//	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
//	button.URL = URL;
//	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
//	button.GUID = identifier;
//
//	// get image with normal link text
//	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
//	[button setImage:normalImage forState:UIControlStateNormal];
//
//	// get image for highlighted link text
//	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
//	[button setImage:highlightImage forState:UIControlStateHighlighted];
//
//	// use normal push action for opening URL
//	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
//
//	// demonstrate combination with long press
//	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//	[button addGestureRecognizer:longPress];
//
//	return button;
//}
//
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        //		if (attachment.hyperLinkURL)
        //		{
        //			// NOTE: this is a hack, you probably want to use your own image view and touch handling
        //			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
        //			imageView.userInteractionEnabled = YES;
        //
        //			DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
        //			button.URL = attachment.hyperLinkURL;
        //			button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
        //			button.GUID = attachment.hyperLinkGUID;
        //
        //			// use normal push action for opening URL
        //			[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
        //
        //			// demonstrate combination with long press
        //			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
        //			[button addGestureRecognizer:longPress];
        
        //			[imageView addSubview:button];
        //		}
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    return nil;
}
//
//- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
//{
//	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
//
//	CGColorRef color = [textBlock.backgroundColor CGColor];
//	if (color)
//	{
//		CGContextSetFillColorWithColor(context, color);
//		CGContextAddPath(context, [roundedRect CGPath]);
//		CGContextFillPath(context);
//
//		CGContextAddPath(context, [roundedRect CGPath]);
//		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
//		CGContextStrokePath(context);
//		return NO;
//	}
//
//	return YES; // draw standard background
//}

#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView relayoutText];
        });
    }
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

- (void)buildWebView {
    
    self.webss = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webss.scrollView.contentInset = UIEdgeInsetsMake(_headerHight, 0, 0, 0);
    [self.webss loadHTMLString:_html baseURL:nil];
    self.webss.backgroundColor = [UIColor whiteColor];
    self.webss.opaque = NO;
    
    [self setBuildWebHead];
    [self.view addSubview:_webss];
}

- (void)setBuildWebHead {
    if (_headView) {
        CGRect rect = _headView.frame;
        rect.origin.y = -self.headerHight;
        [self.webss.scrollView addSubview:_headView];
    }
}

//设置footerView，并计算合适位置；
- (void)setBuildFooterView {
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    
    UIView *viewss = [self.view viewWithTag:99999];
    [viewss removeFromSuperview];
    
    CGSize contentSize = self.webss.scrollView.contentSize;
    
    _footerView.userInteractionEnabled = YES;
    _footerView.tag = 99999;
    _footerView.frame = CGRectMake(0, contentSize.height, self.view.frame.size.width, self.footerHight);
    
    [self.webss.scrollView addSubview:vi];
    self.webss.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + self.footerHight);
    
    //重新监听
    [self addObserverForWebViewContentSize];
}

#pragma mark - set headView 
- (void)setFooterView:(UIView *)footerView {
    _footerView = view;
}

- (void)setHeadView:(UIView *)headView {
    _headView = headView;
    self.textView.headerView = headView;
    [self setBuildWebHead];
}

- (CGPoint)contentOffset {
    return self.textView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.textView.contentOffset = contentOffset;
}

@end
