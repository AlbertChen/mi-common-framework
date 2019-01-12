//
//  UIView+CYAdditions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CYAdditions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat cornerRadius;

- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width;

@property (nonatomic, readonly) UIImage *snapshot;

- (void)removeAllSubviews;

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute firstItem:(id)first secondItem:(id)second;

// Nib
+ (UINib *)nib;
+ (NSString *)nibName;

@end
