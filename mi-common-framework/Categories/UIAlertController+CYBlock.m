//
//  UIAlertController+CYBlock.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 2018/4/2.
//  Copyright © 2018 Chen Yiliang. All rights reserved.
//

#import "UIAlertController+CYBlock.h"
#import "NSString+CYAdditions.h"

@implementation UIAlertController (CYBlock)

+ (instancetype)presentFromController:(UIViewController *)controller
                                title:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitle:(NSString *)otherButtonTitle
                           completion:(void (^)(UIAlertController *alertController, NSUInteger selectedIndex))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (![NSString isEmpty:cancelButtonTitle]) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
                completion(alertController, 0);
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (![NSString isEmpty:otherButtonTitle]) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
                completion(alertController, 1);
            }
        }];
        [alertController addAction:otherAction];
    }
    
    [controller presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

@end
