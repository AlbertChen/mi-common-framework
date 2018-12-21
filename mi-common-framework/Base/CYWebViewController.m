//
//  CYWebViewController.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYWebViewController.h"
#import "UIView+CYAdditions.h"
#import "MBProgressHUD+CYConvenience.h"
#import "UIBarButtonItem+CYAdditions.h"
#import "NJKWebViewProgressView.h"
#import "CYImageBrowserViewController.h"

@interface CYWebViewController () <UIWebViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong, readwrite) UIWebView *webView;
@property (nonatomic, weak) NSLayoutConstraint *webViewBottomLC;
@property (nonatomic, strong, readwrite) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, strong, readwrite) id<CYWebViewController> object;

@end

@implementation CYWebViewController

#pragma mark - Properties

- (NSString *)closeImage {
    return _closeImage ?: @"nav_close";
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    
    if (self.webViewBottomLC.constant != 0.0) {
        self.webViewBottomLC.constant = bottomMargin;
    }
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    
    return _webView;
}

- (NJKWebViewProgress *)progressProxy {
    if (_progressProxy == nil) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (_progressView == nil) {
        CGFloat progressBarHeight = 2.f;
        CGRect barFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _progressView.progress = 0.0;
    }
    
    return _progressView;
}

#pragma mark - Init

- (instancetype)initWithObject:(id<CYWebViewController>)object delegate:(id<CYWebViewControllerDelegate>)delegate {
    self = [self initWithNibName:nil bundle:nil];
    if (self != nil) {
        _object = object;
        _delegate = delegate;
    }
    
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.webView.delegate = nil;
    [self.webView stopLoading];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self.progressProxy;
    [self.view insertSubview:self.webView belowSubview:self.stateView];
    [self setupViewConstraints];
    
    if (self.object != nil) {
        [self displayObject:self.object];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

#pragma mark - Constraints

- (void)setupViewConstraints {
    NSDictionary *views = @{@"webView": self.webView};
    NSDictionary *metrics = @{@"bottomMargin": @(self.bottomMargin)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[webView]-(bottomMargin)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:metrics views:views]];
    
    self.webViewBottomLC = [self.view constraintForAttribute:NSLayoutAttributeBottom firstItem:self.view secondItem:self.webView];
}

#pragma mark - Actions

- (void)backButtonPressed:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismiss:YES];
    }
}

- (void)closeButtonPressed:(id)sender {
    [self dismiss:YES];
}

- (IBAction)stateViewTapped:(CYStateViewState)type {
    [self displayObject:self.object];
}

// URL schema: img://onclick?src=xxx&srcs=xxx,xxx...
- (void)showPhotoBrowserWithURL:(NSURL *)URL {
    NSString *currentSRC = nil;
    NSArray *SRCs = nil;
    NSString *URLString = URL.absoluteString;
    NSRange currentSRCRange = [URLString rangeOfString:@"?src="];
    NSRange SRCsRange = [URLString rangeOfString:@"&srcs="];
    currentSRC = [URLString substringWithRange:NSMakeRange(currentSRCRange.location + currentSRCRange.length, SRCsRange.location - (currentSRCRange.location + currentSRCRange.length))];
    NSString *SRCsString = [URLString substringFromIndex:SRCsRange.location + SRCsRange.length];
    SRCs = [SRCsString componentsSeparatedByString:@","];
    
    NSInteger index = [SRCs indexOfObject:currentSRC];
    if (index == NSNotFound) {
        index = 0;
    }

    CYImageBrowserViewController *browser = [[CYImageBrowserViewController alloc] initWithImageURLs:SRCs placeholder:nil delegate:nil];
    browser.browseIndex = index;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - Public Methods

- (void)displayObject:(id<CYWebViewController>)object {
    if (object == nil) return;
    
    _object = object;
    
    NSURL *url = [NSURL URLWithString:[object URLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([self.delegate respondsToSelector:@selector(webViewController:willSendRequest:)]) {
        [self.delegate webViewController:self willSendRequest:request];
    }
    [self.webView loadRequest:request];
}

- (void)adjustTextSize:(NSInteger)textSize {
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%@%%'", @(textSize)];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:@"tel:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    } else if ([request.URL.absoluteString hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    } else if ([request.URL.absoluteString hasPrefix:@"img://onclick"]) {
        [self showPhotoBrowserWithURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.title == nil) {
        self.title = NSLocalizedString(@"Loading...", @"");
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.title isEqualToString:NSLocalizedString(@"Loading...", @"")]) {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if ([webView canGoBack]) {
        if (self.navigationItem.leftBarButtonItems.count < 2) {
            UIBarButtonItem *closeBarButtonItem = [UIBarButtonItem itemWithImage:self.closeImage target:self selector:@selector(closeButtonPressed:)];
            self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem, closeBarButtonItem];
        }
    } else {
        UIBarButtonItem *backBarButtonItem = self.navigationItem.leftBarButtonItems.count >= 1 ? self.navigationItem.leftBarButtonItems.firstObject : self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }

    if (self.stateView.state == CYStateViewStateError) {
        self.stateView.state = CYStateViewStateNone;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(webViewControllerDidFinishLoad:)]) {
            [self.delegate webViewControllerDidFinishLoad:self];
        }
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) return;

    NSString *failingURLString = [error.userInfo valueForKey:NSURLErrorFailingURLStringErrorKey];
    NSString *targetURLString = webView.request.URL.absoluteString.length > 0 ?  webView.request.URL.absoluteString : [self.object URLString];
    if ([failingURLString isEqualToString:targetURLString]) {
        self.stateView.state = CYStateViewStateError;
    }
//     TODO: Show error message
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
}

@end

@implementation NSString (CYWebViewController)

- (NSString *)URLString {
    return self;
}

- (NSString *)originURLString {
    return self;
}

@end
