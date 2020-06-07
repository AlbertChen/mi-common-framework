//
//  UIWindow+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 24/10/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "UIWindow+CYAdditions.h"

@implementation UIWindow (CYAdditions)

- (UIViewController *)topViewController {
    UIViewController *topViewController = self.rootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    
    return topViewController;
}

@end
