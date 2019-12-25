//
//  CYCountdownButton.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 1/7/19.
//  Copyright (c) 2019 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CYCountdownButton : UIButton

@property (nonatomic, assign, getter=isInCountdown) BOOL inCountdown;
@property (nonatomic, assign) IBInspectable NSTimeInterval timeInterval;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) void (^completion)(void);

- (void)startCountdown;
- (void)stopCountdown;

@end
