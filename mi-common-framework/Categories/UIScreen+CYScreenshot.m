//
//  UIScreen+Screenshot.m
//  Lvdaodao-iOS-ToC
//
//  Created by Chen Yiliang on 3/1/15.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import "UIScreen+CYScreenshot.h"

@implementation UIScreen (CYScreenshot)

+ (UIImage *)screenshot
{
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [window.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
