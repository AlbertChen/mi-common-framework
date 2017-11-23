//
//  CYWebViewController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYViewController.h"
#import "NJKWebViewProgress.h"

@class CYWebViewController;

@protocol CYWebViewController <NSObject>

@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) NSString *originURLString;

@end

@protocol CYWebViewControllerDelegate <NSObject>

@optional
- (void)webViewController:(CYWebViewController *)viewController willSendRequest:(NSMutableURLRequest *)request;
- (void)webViewControllerDidFinishLoad:(CYWebViewController *)viewController;

@end

@interface CYWebViewController : CYViewController <UIWebViewDelegate, NSURLConnectionDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, weak) id<CYWebViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) id<CYWebViewController> object;

- (instancetype)initWithObject:(id<CYWebViewController>)object delegate:(id<CYWebViewControllerDelegate>)delegate;
- (void)displayObject:(id<CYWebViewController>)object;
- (void)adjustTextSize:(NSInteger)textSize;

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong, readonly) NJKWebViewProgress *progressProxy;

- (void)showPhotoBrowserWithURL:(NSURL *)URL;

@end

@interface NSString (CYWebViewController) <CYWebViewController>

@end
