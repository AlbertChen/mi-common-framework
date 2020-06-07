//
//  CYNotificationView.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 25/10/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYNotificationView.h"

@interface CYNotificationView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UIWindow *originalKeyWindow;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) void (^touchedBlock)(CYNotificationView *notificationView);

@end

@implementation CYNotificationView

- (instancetype)initWithIcon:(UIImage *)icon touchedBlock:(void (^)(CYNotificationView *notificationView))touchedBlock {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        blurView.frame = self.contentView.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:blurView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.0, 18.0, 18.0)];
        imageView.image = icon;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        self.touchedBlock = touchedBlock;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self.contentView addGestureRecognizer:tapGesture];
    }
    
    return self;
}

#pragma mark - Actions

- (void)viewTapped:(UIGestureRecognizer *)gestureRecongnizer {
    [self dismissAnimated:YES];
    
    if (self.touchedBlock != nil) {
        self.touchedBlock(self);
    }
}

- (void)showWithTitle:(NSString *)title content:(NSString *)content animated:(BOOL)animated {
    self.originalKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGFloat offsetY = 8.0;
    __block CGRect frame = self.imageView.frame;
    frame.origin.y = offsetY + 2.0;
    self.imageView.frame = frame;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.titleLabel.text = title;
    if (self.titleLabel.text.length > 0) {
        [self.titleLabel sizeToFit];
        frame = self.titleLabel.frame;
        frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.0;
        frame.origin.y = offsetY;
        frame.size.width = screenSize.width - CGRectGetMinX(frame) - 8.0;
        self.titleLabel.frame = frame;
        offsetY += frame.size.height + 3.0;
    }

    self.contentLabel.text = content;
    frame = self.contentLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.0;
    frame.origin.y = offsetY;
    frame.size.width =  screenSize.width - CGRectGetMinX(frame) - 8.0;
    CGSize fittingSize = [self.contentLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
    frame.size.height = ceilf(fittingSize.height);
    self.contentLabel.frame = frame;
    offsetY += frame.size.height + 8.0;
    
    frame = self.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    frame.size.width = screenSize.width;
    frame.size.height = offsetY;
    
    self.hidden = NO;
    [self makeKeyAndVisible];
    
    if (animated) {
        frame.origin.y = -frame.size.height;
        self.frame = frame;
        [UIView animateWithDuration:0.2 animations:^{
            frame.origin.y = 0.0;
            self.frame = frame;
        }];
    }
    
    [self dismissAfterDelay:3.2 animated:animated];
}

- (void)dismissAnimated:(BOOL)animated {
    if (self.hidden) return;
    
    [self.originalKeyWindow makeKeyAndVisible];
    if (animated) {
        CGRect frame = self.frame;
        frame.origin.y = -frame.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self dismiss];
        }];
    } else {
        [self dismiss];
    }
}

- (void)dismiss {
    self.hidden = YES;
    [self stopTimer];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    [self startTimer:delay];
}

#pragma mark - Timer

- (void)timerFire {
    [self dismissAnimated:YES];
}

- (void)startTimer:(NSTimeInterval)interval {
    if (self.timer != nil) {
        [self stopTimer];
    }
    
    self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerFire) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

@end
