//
//  CYConstants.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/21/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#ifndef CYConstants_h
#define CYConstants_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  Define wead/strong instance
 */
#define DEFINE_WEAK_PTR(obj) typeof(obj) __weak w_##obj = obj
#define DEFINE_STRONG_PTR(obj) typeof(obj) __strong s_##obj = obj

/**
 *  A way to implement TODO warning.
 *  http://blog.sunnyxx.com/2015/03/01/todo-macro/
 */
#define TODO_STRINGIFY(S) #S
#define TODO_DEFER_STRINGIFY(S) TODO_STRINGIFY(S)
#define TODO_PRAGMA_MESSAGE(MSG) _Pragma(TODO_STRINGIFY(message(MSG)))
#define TODO_FORMATTED_MESSAGE(MSG) "[TODO-" TODO_DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
TODO_DEFER_STRINGIFY(__FILE__) " line " TODO_DEFER_STRINGIFY(__LINE__)
#define TODO_KEYWORDIFY try {} @catch (...) {}
#define TODO(MSG) TODO_KEYWORDIFY TODO_PRAGMA_MESSAGE(TODO_FORMATTED_MESSAGE(MSG))

/**
 *  App info
 */
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLE_ID   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_BUNDLE_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_BUNDLE_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

/**
 *  Color
 */
#define RGBCOLOR(r,g,b)     RGBACOLOR(r,g,b,1.0)
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *  Device info
 */
#define IS_LANDSCAPE         ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
#define IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE4           (IS_IPHONE && [UIScreen mainScreen].bounds.size.height < 568.0)
#define IS_IPHONE5           (IS_IPHONE && [UIScreen mainScreen].bounds.size.height == 568.0)
#define IS_IPHONE6           (IS_IPHONE && [UIScreen mainScreen].bounds.size.height == 667.0)
#define IS_IPHONE6PLUS       (IS_IPHONE && [UIScreen mainScreen].bounds.size.height == 736.0 || [UIScreen mainScreen].bounds.size.width == 736.0) // Both orientations
#define IS_IPHONEX           (IS_IPHONE && [UIScreen mainScreen].bounds.size.height == 812.0)
#define IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_IOS9_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

inline static CGSize CYScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}

#endif /* CYConstants_h */
