//
//  CYWebViewController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CYViewController.h"

@class CYWebViewController;

@protocol CYWebViewRequestItem <NSObject>

@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) NSString *originURLString;

@end

@protocol CYWebViewControllerDelegate <NSObject>

@optional
- (void)webViewController:(CYWebViewController *)viewController willSendRequest:(NSMutableURLRequest *)request;
- (void)webViewControllerDidFinishLoad:(CYWebViewController *)viewController;

@end

@interface CYWebViewController : CYViewController <WKNavigationDelegate, NSURLConnectionDelegate>

@property (nonatomic, weak) id<CYWebViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *closeImage;
@property (nonatomic, strong, readonly) id<CYWebViewRequestItem> requestItem;

- (instancetype)initWithRequestItem:(id<CYWebViewRequestItem>)requestItem delegate:(id<CYWebViewControllerDelegate>)delegate;
- (void)loadRequestItem:(id<CYWebViewRequestItem>)requestItem;
- (void)adjustTextSize:(NSInteger)textSize;

@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, strong, readonly) WKWebView *webView;


- (void)showPhotoBrowserWithURL:(NSURL *)URL;

@end

@interface NSString (CYWebViewRequestItem) <CYWebViewRequestItem>

@end
