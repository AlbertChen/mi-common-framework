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
    return [[self class] presentFromController:controller
                                         style:UIAlertControllerStyleAlert
                                         title:title
                                       message:message
                             cancelButtonTitle:cancelButtonTitle
                              otherButtonTitle:otherButtonTitle
                                    completion:completion];
}

+ (instancetype)presentFromController:(UIViewController *)controller
                                style:(UIAlertControllerStyle)style
                                title:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitle:(NSString *)otherButtonTitle
                           completion:(void (^)(UIAlertController *alertController, NSUInteger selectedIndex))completion {
    NSArray *otherButtonTitles = nil;
    if (![NSString isEmpty:otherButtonTitle]) {
        otherButtonTitles = @[otherButtonTitle];
    }
    return [[self class] presentFromController:controller
                                         style:style
                                         title:title
                                       message:message
                             cancelButtonTitle:cancelButtonTitle
                             otherButtonTitles:otherButtonTitles
                                    completion:completion];
}

+ (instancetype)presentFromController:(UIViewController *)controller
                                title:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           completion:(void (^)(UIAlertController *alertController, NSUInteger selectedIndex))completion {
    return [[self class] presentFromController:controller
                                         style:UIAlertControllerStyleAlert
                                         title:title
                                       message:message
                             cancelButtonTitle:cancelButtonTitle
                             otherButtonTitles:otherButtonTitles
                                    completion:completion];
}

+ (instancetype)presentFromController:(UIViewController *)controller
                                style:(UIAlertControllerStyle)style
                                title:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           completion:(void (^)(UIAlertController *alertController, NSUInteger selectedIndex))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (![NSString isEmpty:cancelButtonTitle]) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
                completion(alertController, 0);
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    for (int i = 0; i < otherButtonTitles.count; i++) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
                completion(alertController, i + 1);
            }
        }];
        [alertController addAction:otherAction];
    }
    
    [controller presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

@end
