//
//  UIImageView+SDWebImage.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 7/27/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIImageView+CYWebImage.h"
#import "Reachability+CYAdditions.h"

static BOOL _downloadImageInWifiOnly = NO;

@implementation UIImageView (CYWebImage)

+ (BOOL)downloadImageInWifiOnly {
    return _downloadImageInWifiOnly;
}

+ (void)setDownloadImageInWifiOnly:(BOOL)wifiOnly {
    _downloadImageInWifiOnly = wifiOnly;
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder {
    [self setImageWithURLString:urlString placeholderImage:placeholder options:0];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self setImageWithURLString:urlString placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    __weak UIImageView *w_self = self;
    SDWebImageCompletionBlock completedBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil && cacheType == SDImageCacheTypeNone) {
            w_self.alpha = 0.0;
            [UIView animateWithDuration:0.15 animations:^{
                w_self.alpha = 1.0;
            }];
        }
        if (error != nil) {
            CYLogInfo(@"Failed to download image, url = %@, error = %@", imageURL, error);
        }
    };
    [self setImageWithURLString:urlString placeholderImage:placeholder options:options completed:completedBlock];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *newURLString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:newURLString];
    if (url == nil) {
        newURLString = [newURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:newURLString];
    }
    if (_downloadImageInWifiOnly && !isWIFIReachable()) {
        NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        UIImage *cacheImage = [SDWebImageManager.sharedManager.imageCache imageFromDiskCacheForKey:cacheKey];
        self.image = cacheImage != nil ? cacheImage : placeholder;
    } else {
        [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:completedBlock];
    }
}

@end
