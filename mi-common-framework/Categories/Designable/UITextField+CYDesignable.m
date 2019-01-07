//
//  UITextField+CYDesignable.m
//  mi-common-framework
//
//  Created by chenyiliang on 2019/1/6.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import "UITextField+CYDesignable.h"

@implementation UITextField (CYDesignable)

- (UIFont *)placeholderFont {
    return [self valueForKeyPath:@"_placeholderLabel.font"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (UIColor *)placeholderColor {
    return [self valueForKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

@end
