//
//  CYRouter.h
//  mi-common-framework
//
//  Created by chenyiliang on 2018/12/21.
//  Copyright © 2018 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CYRouter : NSObject

+ (instancetype)defaultRouter;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;

// Navigation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

- (BOOL)canPopToViewController:(Class)controllerClass;
- (NSInteger)indexOfViewControllerInNavigationStack:(Class)controllerClass;
- (UIViewController *)viewControllerInNavigationStack:(Class)controllerClass;

// Present
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)dismissViewControllerAnimated:(BOOL)animated;

@end
