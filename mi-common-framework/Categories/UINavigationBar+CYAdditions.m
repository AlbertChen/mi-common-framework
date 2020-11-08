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
        return (UIView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIView *contentView = [self findContentViewFromView:subView];
        if (contentView) {
            return contentView;
        }
    }
    
    return nil;
}

- (BOOL)isSeparatorHidden {
    return self.shadowImage != nil;
}

- (void)setSeparatorHidden:(BOOL)separatorHidden {
    self.shadowImage = separatorHidden ? [UIImage new] : nil;
}

@end
