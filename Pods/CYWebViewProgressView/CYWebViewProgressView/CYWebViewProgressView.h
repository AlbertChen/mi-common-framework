//
//  CYWebViewProgressView.h
//  CYWebViewProgressView
//
//  Created by Chen Yiliang on 2020/3/6.
//  Copyright © 2020 cyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CYWebViewProgressView : UIView

@property (nonatomic, assign) double progress;

@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, assign) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic, assign) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(double)progress animated:(BOOL)animated;

@end

@interface WKWebView (CYWebViewProgressView)

@property (nonatomic) CYWebViewProgressView *progressView;

@end
