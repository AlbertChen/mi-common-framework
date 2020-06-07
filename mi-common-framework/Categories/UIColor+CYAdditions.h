//
//  UIColor+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/25/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEX_COLOR(h)        HEXA_COLOR(h, 1.0)
#define HEXA_COLOR(h, a)    [UIColor colorWithHexString:(h) alpha:(a)]

@interface UIColor (CYAdditions)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
