//
//  UIImageView+SDWebImage.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 7/27/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIImageView+WebCache.h"

@interface UIImageView (CYWebImage)

+ (BOOL)downloadImageInWifiOnly;
+ (void)setDownloadImageInWifiOnly:(BOOL)wifiOnly;

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

// Download with options
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

@end
