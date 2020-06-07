//
//  UIAlertView+Block.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/16/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIAlertView+CYBlock.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) void (^completion)(UIAlertView *alertView, NSUInteger selectedIndex);

@end

@implementation UIAlertView (Block)

- (void (^)(UIAlertView *alertView, NSUInteger selectedIndex))completion {
    return objc_getAssociatedObject(self, @selector(completion));
}

- (void)setCompletion:(void (^)(UIAlertView *, NSUInteger))completion {
    objc_setAssociatedObject(self, @selector(completion), completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(UIAlertView *, NSUInteger))completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    alertView.delegate = alertView;
    alertView.completion = completion;
    [alertView show];
    
    return alertView;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.completion) {
        self.completion(alertView, buttonIndex);
    }
}

@end
