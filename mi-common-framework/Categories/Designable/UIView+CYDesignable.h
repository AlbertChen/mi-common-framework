//
//  UIView+CYDesignable.h
//  mi-common-framework
//
//  Created by chenyiliang on 2019/1/6.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (CYDesignable)

@property (nonatomic, assign) IBInspectable BOOL masksToBounds;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
@property (nonatomic, copy) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;

@end
