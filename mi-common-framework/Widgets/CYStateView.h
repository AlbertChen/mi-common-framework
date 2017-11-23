//
//  BaseStateView.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CYStateViewState) {
    CYStateViewStateNone,
    CYStateViewStateLoading,
    CYStateViewStateError,
    CYStateViewStateEmpty
};

@interface CYStateView : UIView

/**
 *  Set state
 */
@property (nonatomic, assign) CYStateViewState state;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *detailColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, assign) CGFloat iconBottomGap; // icon和文字的间距
@property (nonatomic, assign) BOOL touchBlocked;
@property (nonatomic, assign) BOOL shouldDelayHideLoading;

/**
 *  Actions
 */
@property (nonatomic, readonly) UIButton *button;
- (void)setActionBlock:(void (^)(CYStateViewState state))actionBlock;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *internalTapGestureRecongnizer;
- (void)setTapBlock:(void (^)(CYStateViewState state))tapBlock;

/**
 *  Config text & image
 */
- (void)setTitle:(NSString *)title forState:(CYStateViewState)state;
- (void)setDetail:(NSString *)detail forState:(CYStateViewState)state;
- (void)setImage:(UIImage *)image forState:(CYStateViewState)state;
- (void)setButtonTitle:(NSString *)buttonTitle forState:(CYStateViewState)state;

@end
