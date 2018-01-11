//
//  MBProgressHUD+Convenience.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/20/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CYConvenience)

+ (instancetype)showLoadingHUDAddTo:(UIView *)view animated:(BOOL)animated;

+ (instancetype)showHUDWithMessage:(NSString *)message;
+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view;
+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view offset:(CGPoint)offset;
+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view autoHide:(BOOL)autoHide;

+ (instancetype)showHUDWithImage:(id)image message:(NSString *)message;
+ (instancetype)showHUDWithImage:(id)image message:(NSString *)message view:(UIView *)view;

- (void)updateHUDMessage:(NSString *)message;
- (void)updateHUDMessage:(NSString *)message autoHide:(BOOL)autoHide;

+ (void)hideHUD:(BOOL)animated;
+ (void)hideAllHUDs:(BOOL)animted;

@end
