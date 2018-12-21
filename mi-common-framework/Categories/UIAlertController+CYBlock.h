//
//  UIAlertController+CYBlock.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 2018/4/2.
//  Copyright © 2018 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (CYBlock)

+ (instancetype)presentFromController:(UIViewController *)controller
                                title:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitle:(NSString *)otherButtonTitle
                           completion:(void (^)(UIAlertController *alertController, NSUInteger selectedIndex))completion;

@end
