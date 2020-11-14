//
//  UIBarButtonItem+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIBarButtonItem+CYAdditions.h"

@implementation UIBarButtonItem (CYAdditions)

+ (UIBarButtonItem *)itemWithText:(NSString *)text target:(id)target selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:selector];
    
    return item;
}

+ (UIBarButtonItem *)itemWithText:(NSString *)text target:(id)target selector:(SEL)selector textColor:(UIColor *)textColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)itemWithImage:(id)image target:(id)target selector:(SEL)selector {
    if ([image isKindOfClass:[NSString class]]) {
        image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
    
    return item;
}

+ (UIBarButtonItem *)customItemWithImage:(id)image target:(id)target selector:(SEL)selector {
    return [[self class] customItemWithImage:image selectedImage:nil target:target selector:selector];
}

+ (UIBarButtonItem *)customItemWithImage:(id)image selectedImage:(id)selectedImage target:(id)target selector:(SEL)selector {
    if ([image isKindOfClass:[NSString class]]) {
        image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setImage:image forState:UIControlStateNormal];
    if (selectedImage != nil) {
        if ([selectedImage isKindOfClass:[NSString class]]) {
            selectedImage = [UIImage imageNamed:selectedImage];
        }
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

@end
