//
//  CYMessageView.h
//  MessageViewDemo
//
//  Created by Chen Yiliang on 4/21/17.
//  Copyright © 2017 CYYUN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYMessageViewStyle) {
    CYMessageViewStyleLight,
    CYMessageViewStyleDark
};

@interface CYMessageView : UIView

/**
 * Designated initializer.
 * @param style The appearance style of the message view.
 */
- (instancetype)initWithStyle:(CYMessageViewStyle)style;

/**
 * Designated initializer. The style is CYMessageViewStyleCustom.
 * @param tintColor The message view tint color.
 * @param textColor The message view text color.
 */
- (instancetype)initWithTintColor:(UIColor *)tintColor textColor:(UIColor *)textColor;

/**
 * The appearance style of the message view.
 * @b Default: CYMessageViewStyleLight.
 */
@property (nonatomic, assign, readonly) CYMessageViewStyle style;

/**
 * The message view tint color.
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 * The message view text color.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * The content view inside the message view. If you want to add additinal views to the message view you should add them as subview to contentView.
 */
@property (nonatomic, strong) UIView *contentView;

/**
 * The label used to present text.
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 * @return Whether the message view is visible on screen.
 */
@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;


/**
 * Show the message view animated.
 * @param view The view to show the message view in.
 */
- (void)showInView:(UIView *)view;

/**
 * Show the message view.
 * @param view The view to show the message view in.
 * @param animated If message view should show with an animation.
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 * Dismiss the message view animated.
 */
- (void)dismiss;

/**
 * Dismiss the message view.
 * @param animated If message view should dismiss with an animation.
 */
- (void)dismissAnimated:(BOOL)animated;

/**
 * Dismiss the message view animated after a delay.
 * @param delay The delay unitl the message view will be dismissed.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay;

/**
 * Dismiss the message after a delay.
 * @param delay The delay unitl the message view will be dismissed.
 * @param animated If message view should dismiss with an animation.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

@end
