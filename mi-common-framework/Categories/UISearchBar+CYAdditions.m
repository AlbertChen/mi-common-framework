//
//  UISearchBar+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 21/09/2017.
//  Copyright © 2017 CYYUN. All rights reserved.
//

#import "UISearchBar+CYAdditions.h"

@implementation UISearchBar (CYAdditions)

- (UITextField *)textFieldInView:(UIView *)view {
    UITextField *textField = nil;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)subview;
            break;
        } else {
            textField = [self textFieldInView:subview];
            if (textField != nil) {
                break;
            }
        }
    }
    
    return textField;
}

- (UITextField *)textField {
    UITextField *textField = [self textFieldInView:self];
    return textField;
}

- (UIButton *)cancelButton {
    UIButton *cancelButton = [self valueForKey:@"_cancelButton"];
    return cancelButton;
}

@end
