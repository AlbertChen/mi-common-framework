//
//  ImageDisplayView.h
//
//  Created by Chen Yiliang on 3/16/15.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYImageDisplayView : UIView <UIScrollViewDelegate>

+ (instancetype)displayWithImage:(UIImage *)image inView:(UIView *)view;
+ (instancetype)displayWithPlaceholder:(UIImage *)placeholder urlString:(NSString *)urlString inView:(UIView *)view;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (instancetype)initWithFrame:(CGRect)frame placeholder:(UIImage *)placeholder urlString:(NSString *)urlString;

- (void)setImage:(UIImage *)image;
- (void)setZoomScale:(CGFloat)zoomScale;
- (void)setBounceHorizontalEnabled:(BOOL)enabled;

- (void)displayInView:(UIView *)view;
- (void)hide;

@end
