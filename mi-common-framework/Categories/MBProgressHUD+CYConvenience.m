//
//  MBProgressHUD+Convenience.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "MBProgressHUD+CYConvenience.h"

#define HUD_CONTENT_MARGIN  10.0
#define HUD_CONTENT_FONT    [UIFont boldSystemFontOfSize:15.0]
#define HUD_CONTENT_COLOR   [UIColor whiteColor]
#define HUD_CONTENT_BACKGROUND_COLOR    [UIColor colorWithWhite:0.0 alpha:0.7]

@implementation MBProgressHUD (CYConvenience)

+ (instancetype)showLoadingHUDAddTo:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.contentColor = HUD_CONTENT_COLOR;
    hud.bezelView.color = HUD_CONTENT_BACKGROUND_COLOR;
    return hud;
}

+ (instancetype)showHUDWithMessage:(NSString *)message {
    return [[self class] showHUDWithMessage:message view:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view {
    return [[self class] showHUDWithMessage:message view:view autoHide:YES];
}

+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view offset:(CGPoint)offset {
    return [[self class] showHUDForView:view message:message offset:offset autoHide:YES animated:YES];
}

+ (instancetype)showHUDWithMessage:(NSString *)message view:(UIView *)view autoHide:(BOOL)autoHide {
    return [[self class] showHUDForView:view message:message autoHide:autoHide animated:YES];
}

+ (instancetype)showHUDForView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide animated:(BOOL)animated {
    CGPoint offset = CGPointMake(0.f, -MBProgressMaxOffset);
    return [[self class] showHUDForView:view message:message offset:offset autoHide:autoHide animated:animated];
}

+ (instancetype)showHUDForView:(UIView *)view message:(NSString *)message offset:(CGPoint)offset autoHide:(BOOL)autoHide animated:(BOOL)animated {
    if (view == nil) return nil;
        
    [MBProgressHUD hideHUDForView:view animated:animated];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.offset = offset;
    hud.margin = HUD_CONTENT_MARGIN;
    hud.contentColor = HUD_CONTENT_COLOR;
    hud.bezelView.color = HUD_CONTENT_BACKGROUND_COLOR;
    [hud updateHUDMessage:message autoHide:autoHide];
    return hud;
}

+ (instancetype)showHUDWithImage:(id)image message:(NSString *)message {
    return [[self class] showHUDWithImage:image message:message view:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showHUDWithImage:(id)image message:(NSString *)message view:(UIView *)view {
    if ([image isKindOfClass:[NSString class]]) {
        image = [UIImage imageNamed:image];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = HUD_CONTENT_MARGIN;
    hud.contentColor = HUD_CONTENT_COLOR;
    hud.bezelView.color = HUD_CONTENT_BACKGROUND_COLOR;
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    
    [hud hideAnimated:YES afterDelay:2.0];
    
    return hud;
}

- (void)updateHUDMessage:(NSString *)message {
    [self updateHUDMessage:message autoHide:YES];
}

- (void)updateHUDMessage:(NSString *)message autoHide:(BOOL)autoHide {
//    self.label.text = message;
    self.detailsLabel.font = HUD_CONTENT_FONT;
    self.detailsLabel.text = message;
    if (autoHide) {
        [self hideAnimated:YES afterDelay:2.0];
    }
}

+ (void)hideHUD:(BOOL)animated {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:animated];
}

+ (void)hideAllHUDs:(BOOL)animted {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:animted];
}

@end
