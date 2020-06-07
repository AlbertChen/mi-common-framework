//
//  BaseStateView.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYStateView.h"
#import "MBProgressHUD+CYConvenience.h"
#import "Reachability+CYAdditions.h"

@interface CYStateView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) MBProgressHUD *loading;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableDictionary *titleData;
@property (nonatomic, strong) NSMutableDictionary *detailData;
@property (nonatomic, strong) NSMutableDictionary *imageData;
@property (nonatomic, strong) NSMutableDictionary *buttonTitleData;

@property (nonatomic, strong, readwrite) UITapGestureRecognizer *internalTapGestureRecongnizer;
@property (nonatomic, copy) void (^tapBlock)(CYStateViewState state);
@property (nonatomic, copy) void (^actionBlock)(CYStateViewState state);

@property (nonatomic, strong) NSLayoutConstraint *iconHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *iconBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelCenterYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *buttonTopConstraint;

@end

@implementation CYStateView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Config
- (void)commonInit
{
    self.titleFont = [UIFont systemFontOfSize:17];
    self.detailFont = [UIFont systemFontOfSize:14];
    self.titleColor = RGB_COLOR(51, 51, 51);
    self.detailColor = RGB_COLOR(167, 174, 175);
    self.iconBottomGap = 0.0;
    self.state = CYStateViewStateNone;
    self.titleData = @{}.mutableCopy;
    self.detailData = @{}.mutableCopy;
    self.imageData = @{}.mutableCopy;
    self.buttonTitleData = @{}.mutableCopy;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.touchBlocked = YES;
    self.shouldDelayHideLoading = NO;
    
    [self configView];
}

- (void)configView
{
    [self removeConstraints:self.constraints];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.label];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.icon];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.contentEdgeInsets = UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0);
    self.button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.button.layer.cornerRadius = 2.0;
    self.button.layer.masksToBounds = YES;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    // Constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_label, _icon, _button);
    NSArray *constraints = nil;
    // label
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_label]-20-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    self.labelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    self.labelCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:@[self.labelHeightConstraint, self.labelCenterYConstraint]];
    // icon
    self.iconHeightConstraint = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:95];
    self.iconBottomConstraint = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeTop multiplier:1 constant:self.iconBottomGap];
    [self addConstraints:@[self.iconHeightConstraint, self.iconBottomConstraint]];
    constraints = @[[NSLayoutConstraint constraintWithItem:_icon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label]-15-[_button]" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    self.buttonTopConstraint = constraints.firstObject;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self addConstraint:constraint];
    
    self.internalTapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    self.internalTapGestureRecongnizer.delegate = self;
    [self addGestureRecognizer:self.internalTapGestureRecongnizer];
}

#pragma mark -

- (NSString *)titleForState:(CYStateViewState)state
{
    NSString *text = self.titleData[@(state)];
    if (!text) {
        if (state == CYStateViewStateError) {
            text = @"网络不给力";
        } else if (state == CYStateViewStateEmpty) {
            text = @"暂无数据";
        }
    }
    return text;
}

- (NSString *)detailForState:(CYStateViewState)state
{
    NSString *detail = self.detailData[@(state)];
    if (!detail) {
        if (state == CYStateViewStateError && !isNetworkReachable()) {
            detail = @"请检查网络连接，然后点击重试";
        }
    }
    return detail;
}

- (UIImage *)imageForState:(CYStateViewState)state
{
    UIImage *image = self.imageData[@(state)];
    if (!image) {
        if (state == CYStateViewStateError && !isNetworkReachable()) {
            image = [UIImage imageNamed:@"icon_no_network"];
        } else {
            image = [UIImage imageNamed:@"icon_no_content"];
        }
    }
    return image;
}

- (NSString *)buttonTitleForState:(CYStateViewState)state
{
    NSString *title = self.buttonTitleData[@(state)];
    return title;
}

- (void)setTitle:(NSString *)title forState:(CYStateViewState)state
{
    if (title) {
        self.titleData[@(state)] = title;
    } else {
        [self.titleData removeObjectForKey:@(state)];
    }
    if (state == self.state) {
        [self updateView];
    }
}

- (void)setDetail:(NSString *)detail forState:(CYStateViewState)state
{
    if (detail) {
        self.detailData[@(state)] = detail;
    } else {
        [self.detailData removeObjectForKey:@(state)];
    }
    if (state == self.state) {
        [self updateView];
    }
}

- (void)setImage:(UIImage *)image forState:(CYStateViewState)state
{
    if (image) {
        self.imageData[@(state)] = image;
    } else {
        [self.imageData removeObjectForKey:@(state)];
    }
    if (state == self.state) {
        [self updateView];
    }
}

- (void)setButtonTitle:(NSString *)buttonTitle forState:(CYStateViewState)state
{
    if (buttonTitle) {
        self.buttonTitleData[@(state)] = buttonTitle;
    } else {
        [self.buttonTitleData removeObjectForKey:@(state)];
    }
    if (state == self.state) {
        [self updateView];
    }
}

#pragma mark - Setter
- (void)setState:(CYStateViewState)state
{
    _state = state;
    
    [self updateView];
}

#pragma mark - Action

- (IBAction)viewTapped:(id)sender {
    if (self.button.hidden && self.tapBlock) {
        self.tapBlock(self.state);
    }
}

- (IBAction)buttonPressed:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(self.state);
    }
}

#pragma mark - Update
- (void)updateView
{
    switch (self.state) {
        case CYStateViewStateNone:
        {
            if (self.loading != nil && self.loading.superview != nil && ![self.loading isHidden] && self.shouldDelayHideLoading) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.state == CYStateViewStateNone) {
                        self.hidden = YES;
                        [self.loading hideAnimated:NO];
                    }
                });
            } else {
                self.hidden = YES;
                [self.loading hideAnimated:NO];
            }
        }
            break;
        case CYStateViewStateLoading:
        {
            self.hidden = NO;
            self.label.hidden = self.icon.hidden = self.button.hidden = YES;
            if (self.loading == nil || self.loading.superview == nil) {
                self.loading = [MBProgressHUD showLoadingHUDAddTo:self animated:YES];
                self.loading.userInteractionEnabled = NO;
            }
        }
            break;
        case CYStateViewStateEmpty:
        {
            self.hidden = NO;
            self.label.hidden = self.icon.hidden = NO;
            [self.loading hideAnimated:YES];
        }
            break;
        case CYStateViewStateError:
        {
            self.hidden = NO;
            self.label.hidden = self.icon.hidden = NO;
            [self.loading hideAnimated:YES];
        }
            break;
        default:
            break;
    }
    
    if (self.state == CYStateViewStateEmpty || self.state == CYStateViewStateError) {
        NSString *title = [self titleForState:self.state];
        NSString *detail = [self detailForState:self.state];
        UIImage *image = [self imageForState:self.state];
        // label
        NSMutableString *string = [[NSMutableString alloc] init];
        if (title.length > 0) {
            [string appendString:title];
        }
        if (detail.length > 0) {
            if (string.length > 0) {
                [string appendString:@"\n"];
            }
            [string appendString:detail];
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.lineSpacing = 5.0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : self.titleFont, NSForegroundColorAttributeName : self.titleColor, NSParagraphStyleAttributeName: paragraphStyle}];
        if (detail.length > 0) {
            NSRange range = [string rangeOfString:detail];
            [attributedString setAttributes:@{NSFontAttributeName : self.detailFont, NSForegroundColorAttributeName : self.detailColor} range:range];
        }
        CGRect rect = [attributedString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        self.label.attributedText = attributedString;
        self.labelHeightConstraint.constant = ceil(MIN(MAX(rect.size.height, 0), 140));
        
        // icon
        CGSize size = image.size;
        self.icon.image = image;
        self.iconHeightConstraint.constant = MIN(size.height, 100);
        self.iconBottomConstraint.constant = -self.iconBottomGap;
        
        NSString *buttonTitle = [self buttonTitleForState:self.state];
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        self.button.hidden = buttonTitle.length == 0;
        if (self.button.hidden) {
            self.labelCenterYConstraint.constant = (self.iconHeightConstraint.constant + self.iconBottomGap) / 2;
        }
        
        [self layoutIfNeeded];
    }
}

#pragma mark - Touch

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point)) {
        return self.touchBlocked;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - UIGestureRecognizerDelegate 

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.state == CYStateViewStateEmpty || self.state == CYStateViewStateError;
}

@end
