//
//  CYNavigationController.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 6/7/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYNavigationController.h"

@interface CYNavigationController ()

@end

@implementation CYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.navigationBar.translucent = NO;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - Transition

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.transitionInProcess) return;
    
    self.transitionInProcess = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
    viewController.hidesBottomBarWhenPushed = !(self.viewControllers.count == 0);
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.transitionInProcess) return nil;
    
    UIViewController *viewController = nil;
    if (self.viewControllers.count > 0) {
        self.transitionInProcess = YES;
        viewController = [super popViewControllerAnimated:animated];
        if (viewController == nil) {
            self.transitionInProcess = NO;
        }
    }
    
    return viewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.transitionInProcess) return nil;
    
    NSArray *viewControllers = nil;
    if ([self.viewControllers containsObject:viewController]) {
        self.transitionInProcess = YES;
        viewControllers = [super popToViewController:viewController animated:animated];
        if (viewControllers.count == 0) {
            self.transitionInProcess = NO;
        }
    }
    
    return viewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.transitionInProcess) return nil;
    
    self.transitionInProcess = YES;
    NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
    if (viewControllers.count == 0) {
        self.transitionInProcess = NO;
    }
    
    return viewControllers;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __weak typeof(self) w_self = self;
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            w_self.transitionInProcess = NO;
        }
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.transitionInProcess = NO;
    self.interactivePopGestureRecognizer.enabled = YES;
}

@end
