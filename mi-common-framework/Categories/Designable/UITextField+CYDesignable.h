//
//  UITextField+CYDesignable.h
//  mi-common-framework
//
//  Created by chenyiliang on 2019/1/6.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UITextField (CYDesignable)

@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@end
