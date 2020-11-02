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
#import "CYImageBrowserViewController.h"
#import "CYWebViewProgressView.h"

@interface CYWebViewController ()

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, weak) NSLayoutConstraint *webViewBottomLC;

@property (nonatomic, strong, readwrite) id<CYWebViewRequestItem> requestItem;

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

- (WKWebView *)webView {
    if (_webView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        _webView = [[WKWebView alloc] initWithFrame:frame];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
//        _webView.scalesPageToFit = YES;
        _webView.navigationDelegate = self;
        
        frame.size.height = 2.0;
        CYWebViewProgressView *progressView = [[CYWebViewProgressView alloc] initWithFrame:frame];
        _webView.progressView = progressView;
    }
    
    return _webView;
}

#pragma mark - Init

- (instancetype)initWithRequestItem:(id<CYWebViewRequestItem>)item delegate:(id<CYWebViewControllerDelegate>)delegate {
    self = [self initWithNibName:nil bundle:nil];
    if (self != nil) {
        _requestItem = item;
        _delegate = delegate;
    }
    
    return self;
}

- (void)dealloc {
    _delegate = nil;
    _webView.progressView = nil;
    _webView.navigationDelegate = nil;
    [_webView stopLoading];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.webView belowSubview:self.stateView];
    [self setupViewConstraints];
    
    if (self.requestItem != nil) {
        [self loadRequestItem:self.requestItem];
    }
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
        [self closeButtonPressed:sender];
    }
}

- (void)closeButtonPressed:(id)sender {
    [self dismiss:YES];
}

- (IBAction)stateViewTapped:(CYStateViewState)type {
    if (self.webView.canGoBack) {
        [self.webView reload];
    } else {
        [self loadRequestItem:self.requestItem];
    }
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

- (void)loadRequestItem:(id<CYWebViewRequestItem>)requestItem {
    if (requestItem == nil) return;
    
    _requestItem = requestItem;
    
    NSURL *url = [NSURL URLWithString:[requestItem URLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([self.delegate respondsToSelector:@selector(webViewController:willSendRequest:)]) {
        [self.delegate webViewController:self willSendRequest:request];
    }
    [self.webView loadRequest:request];
}

- (void)adjustTextSize:(NSInteger)textSize {
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%@%%'", @(textSize)];
    [self.webView evaluateJavaScript:jsString completionHandler:NULL];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if ([request.URL.absoluteString hasPrefix:@"tel:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        policy = WKNavigationActionPolicyCancel;
    } else if ([request.URL.absoluteString hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        policy = WKNavigationActionPolicyCancel;
    } else if ([request.URL.absoluteString hasPrefix:@"img://onclick"]) {
        [self showPhotoBrowserWithURL:request.URL];
        policy = WKNavigationActionPolicyCancel;
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.title == nil) {
        self.title = NSLocalizedString(@"Loading...", @"");
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.title isEqualToString:NSLocalizedString(@"Loading...", @"")]) {
        [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            self.title = title;
        }];
    }
    
    if ([webView canGoBack]) {
        if (self.navigationItem.leftBarButtonItems != nil &&  self.navigationItem.leftBarButtonItems.count < 2) {
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

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) return;

    NSString *failingURLString = [error.userInfo valueForKey:NSURLErrorFailingURLStringErrorKey];
    NSString *targetURLString = webView.URL.absoluteString.length > 0 ?  webView.URL.absoluteString : [self.requestItem URLString];
    if ([failingURLString isEqualToString:targetURLString] ||
        [failingURLString isEqualToString:[targetURLString stringByAppendingString:@"/"]]) {
        self.stateView.state = CYStateViewStateError;
    }
    
    // TODO: Show error message
}

@end

@implementation NSString (CYWebViewRequestItem)

- (NSString *)URLString {
    return self;
}

- (NSString *)originURLString {
    return self;
}

@end
