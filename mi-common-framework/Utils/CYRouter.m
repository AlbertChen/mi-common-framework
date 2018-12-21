//
//  CYRouter.m
//  mi-common-framework
//
//  Created by chenyiliang on 2018/12/21.
//  Copyright © 2018 Chen Yiliang. All rights reserved.
//

#import "CYRouter.h"

@implementation CYRouter

+ (instancetype)defaultRouter {
    static id router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[[self class] alloc] init];
    });
    return router;
}

- (UIViewController *)currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentViewController = rootViewController;
    while (YES) {
        if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            currentViewController = [(UITabBarController *)currentViewController selectedViewController];
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            currentViewController = [(UINavigationController *)currentViewController visibleViewController];
        } else if (currentViewController.presentedViewController != nil) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            return currentViewController;
        }
    }
}

// Navigation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.currentViewController.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.currentViewController.navigationController popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self.currentViewController.navigationController popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.currentViewController.navigationController popToRootViewControllerAnimated:animated];
}

- (BOOL)canPopToViewController:(Class)controllerClass {
    return [self viewControllerInNavigationStack:controllerClass] != nil ? YES : NO;
}

- (UIViewController *)viewControllerInNavigationStack:(Class)controllerClass {
    NSArray *viewControllers = self.currentViewController.navigationController.viewControllers;
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:controllerClass]) {
            return viewController;
        }
    }
    return nil;
}

// Present
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.currentViewController presentViewController:viewController animated:animated completion:NULL];
}

- (void)dismissViewControllerAnimated:(BOOL)animated {
    [self.currentViewController dismissViewControllerAnimated:animated completion:NULL];
}

@end
