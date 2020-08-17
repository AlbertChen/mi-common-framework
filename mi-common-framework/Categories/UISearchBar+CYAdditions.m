//
//  UISearchBar+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 21/09/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "UISearchBar+CYAdditions.h"

@implementation UISearchBar (CYAdditions)

- (UIView *)subviewWithClass:(Class)aClass inView:(UIView *)view {
    UIView *result = nil;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:aClass]) {
            result = subview;
            break;
        } else {
            result = [self subviewWithClass:aClass inView:subview];
            if (result != nil) {
                break;
            }
        }
    }
    
    return result;
}

- (UITextField *)textField {
    UITextField *textField = nil;
    if (@available(iOS 13.0, *)) {
        textField = self.searchTextField;
    } else {
        textField = (UITextField *)[self subviewWithClass:[UITextField class] inView:self];
    }
    return textField;
}

- (UIButton *)cancelButton {
    UIButton *cancelButton = nil;
    if (@available(iOS 13.0, *)) {
        cancelButton = (UIButton *)[self subviewWithClass:[UIButton class] inView:self];
    } else {
        cancelButton = [self valueForKey:@"_cancelButton"];
    }
    return cancelButton;
}

@end
