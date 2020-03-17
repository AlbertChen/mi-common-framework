//
//  CYWebViewProgressView.m
//  CYWebViewProgressView
//
//  Created by Chen Yiliang on 2020/3/6.
//  Copyright © 2020 cyl. All rights reserved.
//

#import "CYWebViewProgressView.h"


@interface CYWebViewProgressView ()

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation CYWebViewProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureViews];
}

- (void)configureViews {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

- (void)setWebView:(WKWebView *)webView {
    if (_webView == webView) return;
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView = webView;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)setProgress:(double)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(double)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self.progressBarView.frame = frame;
    } completion:nil];

    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.progressBarView.frame;
            frame.size.width = 0;
            self.progressBarView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        double progress = [[change valueForKey:NSKeyValueChangeNewKey] doubleValue];
        [self setProgress:progress animated:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end

@implementation WKWebView (CYWebViewProgressView)

- (CYWebViewProgressView *)progressView {
    CYWebViewProgressView *progressView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CYWebViewProgressView class]]) {
            progressView = (CYWebViewProgressView *)view;
            break;
        }
    }
    return progressView;
}

- (void)setProgressView:(CYWebViewProgressView *)progressView {
    [self addSubview:progressView];
    [progressView setWebView:self];
}

@end
