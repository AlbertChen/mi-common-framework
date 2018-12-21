//
//  UIBarButtonItem+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CYAdditions)

+ (UIBarButtonItem *)itemWithText:(NSString *)text target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)itemWithText:(NSString *)text target:(id)target selector:(SEL)selector textColor:(UIColor *)textColor;
+ (UIBarButtonItem *)itemWithImage:(id)image target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)customItemWithImage:(id)image target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)customItemWithImage:(id)image selectedImage:(id)selectedImage target:(id)target selector:(SEL)selector;

@end
