//
//  UIAlertView+Block.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/16/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                               message:(NSString *)message
                            completion:(void (^)(UIAlertView *alertView, NSUInteger selectedIndex))completion
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
