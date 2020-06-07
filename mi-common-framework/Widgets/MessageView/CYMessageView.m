//
//  CYMessageView.m
//  MessageViewDemo
//
//  Created by Chen Yiliang on 4/21/17.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYMessageView.h"

const static CGFloat CYMessageViewTextFontSize = 13.0f;

@interface CYMessageView ()

@property (nonatomic, assign, readwrite) CYMessageViewStyle style;

@end

@implementation CYMessageView

#pragma mark - Getter & Setter

- (UIColor *)tintColor {
    return self.contentView.backgroundColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    self.contentView.backgroundColor = tintColor;
}

- (UIColor *)textColor {
    return self.textLabel.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _contentView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:CYMessageViewTextFontSize];
    }
    
    return _textLabel;
}

#pragma mark - Init & Dealloc

- (void)dealloc {
    [self.textLabel removeObserver:self forKeyPath:@"text" context:NULL];
}

- (instancetype)initWithStyle:(CYMessageViewStyle)style {
    UIColor *tintColor = nil;
    UIColor *textColor = nil;
    if (style == CYMessageViewStyleLight) {
        tintColor = [UIColor whiteColor];
        textColor = [UIColor blackColor];
    } else {
        tintColor = [UIColor blackColor];
        textColor = [UIColor whiteColor];
    }
    
    self = [self initWithTintColor:tintColor textColor:textColor];
    if (self != nil) {
        _style = style;
    }
    
    return self;
}

- (instancetype)initWithTintColor:(UIColor *)tintColor textColor:(UIColor *)textColor {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = tintColor;
        self.textColor = textColor;
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.textLabel];
        
        [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
        
        [self setupLayoutConstraints];
    }
    
    return self;
}

#pragma mark -

- (void)setupLayoutConstraints {
    NSDictionary *views = @{
                                @"contentView": self.contentView,
                                @"textLabel": self.textLabel
                            };
    NSDictionary *metrics = @{};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[textLabel]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[textLabel]-6-|" options:0 metrics:metrics views:views]];
}

- (CGSize)sizeWithFittingWidth:(CGFloat)width {
    if (self.textLabel.text.length == 0) {
        self.textLabel.text = @" ";
    }
    
    CGRect frame = self.frame;
    CGSize fittingSize = [self systemLayoutSizeFittingSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
    return fittingSize;
}

- (void)adjustHeightIfNeed {
    if (self.frame.size.width == 0.0 || ![self isVisible]) return;
    
    CGRect frame = self.frame;
    CGSize fittingSize = [self sizeWithFittingWidth:frame.size.width];
    frame.size.height = fittingSize.height;
    self.frame = frame;
}

#pragma mark - Show 

- (BOOL)isVisible {
    return self.superview != nil;
}

- (void)showInView:(UIView *)view {
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
   __block CGRect frame = self.frame;
    CGSize size = [self sizeWithFittingWidth:view.bounds.size.width];
    frame.size.width = view.frame.size.width;
    frame.size.height = size.height;
    
    [view addSubview:self];
    
    if (animated) {
        frame.origin.y = -frame.size.height;
        self.frame = frame;
        [UIView animateWithDuration:0.5 animations:^{
            frame.origin.y = 0.0;
            self.frame = frame;
        } completion:NULL];
    } else {
        frame.origin.y = 0.0;
        self.frame = frame;
    }
}

#pragma mark - Dismisss

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    if (![self isVisible]) return;
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = -frame.size.height;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)dismissAfterDelay:(NSTimeInterval)delay {
    [self dismissAfterDelay:delay animated:YES];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    __weak typeof(self) w_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [w_self dismissAnimated:animated];
    });
}

#pragma mark - Observer 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] && object == self.textLabel) {
        [self adjustHeightIfNeed];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
