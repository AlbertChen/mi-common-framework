//
//  UIView+CYAdditions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIView+CYAdditions.h"

@implementation UIView (CYAdditions)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.bounds.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = cornerRadius > 0.0;
    // Performance improvement here depends on the size of your view
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute firstItem:(id)first secondItem:(id)second {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d AND firstItem = %@ AND secondItem = %@", attribute, first, second];
    return [[self.constraints filteredArrayUsingPredicate:predicate] firstObject];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[[self class] nibName] bundle:nil];
}

+ (NSString *)nibName {
    return NSStringFromClass([self class]);
}

@end
