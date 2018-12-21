//
//  UINavigationBar+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 13/10/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "UINavigationBar+CYAdditions.h"

@implementation UINavigationBar (CYAdditions)

- (UIView *)contentView {
    UIView *contentView = [self findContentViewFromView:self];
    return contentView;
}

- (UIView *)findContentViewFromView:(UIView *)view {
    if ([view isKindOfClass:[UIView class]] && view.frame.size.height == 44.0 && view != self ) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIView *contentView = [self findContentViewFromView:subView];
        if (contentView) {
            return contentView;
        }
    }
    
    return nil;
}


- (void)hidenSeparator:(BOOL)hiden {
    UIImageView *lineView = [self findSeparatorFromView:self];
    lineView.hidden = hiden;
}

- (UIImageView *)findSeparatorFromView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 2.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findSeparatorFromView:subView];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

@end
