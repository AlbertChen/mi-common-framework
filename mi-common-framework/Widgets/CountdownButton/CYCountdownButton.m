//
//  CYCountdownButton.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 1/7/19.
//  Copyright (c) 2019 Chen Yiliang. All rights reserved.
//

#import "CYCountdownButton.h"

const static NSTimeInterval kTimeIntervalDefaultValue = 60.0f;

@interface CYCountdownButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval backwardsTimeInterval;
@property (nonatomic, strong) NSString *disabledTitle;

@end

@implementation CYCountdownButton

- (void)dealloc
{
    [self stopCountdown];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString *disabledTitle = [self titleForState:UIControlStateDisabled];
    if (disabledTitle == nil || disabledTitle.length == 0) {
        disabledTitle = [self titleForState:UIControlStateNormal];
        [self setTitle:disabledTitle forState:UIControlStateDisabled];
    }
    self.disabledTitle = disabledTitle;
}

#pragma mark - Property

- (BOOL)isCountingDown {
    return _countingDown;
}

- (UILabel *)countdownLabel
{
    if (_countdownLabel == nil) {
        _countdownLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _countdownLabel.font = self.titleLabel.font;
        _countdownLabel.textColor = [self titleColorForState:UIControlStateDisabled];
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _countdownLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _countdownLabel;
}

#pragma mark - Public Methods

- (void)startCountdown
{
    _countingDown = YES;
    self.enabled = NO;
    [self setTitle:@"" forState:UIControlStateDisabled];
    _backwardsTimeInterval = _timeInterval == 0.0 ? kTimeIntervalDefaultValue : _timeInterval;
    
    NSString *format = [self timeFormat];
    NSString *title = [NSString stringWithFormat:format, (int)_backwardsTimeInterval];
    self.countdownLabel.text = title;
    
    if (![self.countdownLabel.superview isEqual:self]) {
        [self addSubview:self.countdownLabel];
    }
    
    [self startTimer];
}

- (void)stopCountdown
{
    [self stopTimer];
    
    _countingDown = NO;
    self.enabled = YES;
    [self.countdownLabel removeFromSuperview];
    [self setTitle:self.disabledTitle forState:UIControlStateDisabled];
    
    if (self.completion) {
        self.completion();
    }
}

#pragma mark - Private Methods

- (NSString *)timeFormat {
    NSString *format = nil;
    CGFloat timeInterval = _timeInterval == 0.0 ? kTimeIntervalDefaultValue : _timeInterval;
    if (timeInterval >= 100) {
        format = @"%03ds";
    } else if (timeInterval >= 10) {
        format = @"%02ds";
    } else {
        format = @"%ds";
    }
    
    return format;
}

- (void)stopTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startTimer
{
    [self stopTimer];
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFireHandler) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerFireHandler
{
    _backwardsTimeInterval = _backwardsTimeInterval - 1.0;
    if (_backwardsTimeInterval < 1.0) {
        [self stopCountdown];
        return;
    }
    
    NSString *format = [self timeFormat];
    NSString *title = [NSString stringWithFormat:format, (int)_backwardsTimeInterval];
    self.countdownLabel.text = title;
}

@end
