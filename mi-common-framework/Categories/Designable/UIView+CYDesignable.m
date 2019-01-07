//
//  UIView+CYDesignable.m
//  mi-common-framework
//
//  Created by chenyiliang on 2019/1/6.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import "UIView+CYDesignable.h"

@implementation UIView (CYDesignable)

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = [shadowColor CGColor];
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

@end
