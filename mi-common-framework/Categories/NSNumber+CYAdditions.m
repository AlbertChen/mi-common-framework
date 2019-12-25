//
//  NSNumber+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 2019/12/25.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import "NSNumber+CYAdditions.h"

@implementation NSNumber (CYAdditions)

- (NSString *)stringWithDecimalDigits:(NSUInteger)digits {
    return [self stringWithDecimalDigits:digits shrinkTimes:1];
}

- (NSString *)stringWithDecimalDigits:(NSUInteger)digits shrinkTimes:(NSInteger)shrinkTimes {
    NSString *format = [[NSString alloc] initWithFormat:@"%@%d%@", @"%.0", (int)digits, @"f"];
    CGFloat num = self.floatValue;
    if (shrinkTimes != 0) {
        num = num / shrinkTimes;
    }
    NSString *result = [NSString stringWithFormat:format, num];
    
    return result;
}

- (NSString *)stringByCutOffWithDecimalDigits:(NSUInteger)digits {
    return [self stringByCutOffWithDecimalDigits:digits shrinkTimes:1];
}

- (NSString *)stringByCutOffWithDecimalDigits:(NSUInteger)digits shrinkTimes:(NSInteger)shrinkTimes {
    NSString *result = nil;
    double num = self.doubleValue;
    if (shrinkTimes != 0) {
        num = num / shrinkTimes;
    }
    
    if (digits == 0) {
        result = @((NSInteger)num).stringValue;
    } else {
        double times = pow(10, digits);
        num = floor(times * num) / times;
        
        result = [@(num) stringWithDecimalDigits:digits];
    }
    
    return result;
}

- (NSString *)stringWithFractionDigits:(NSUInteger)digits {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:digits];
    [formatter setMinimumFractionDigits:digits];
    NSString *result = [formatter stringFromNumber:self];
    
    return result;
}

- (NSString *)stringWithNumberStyle:(NSNumberFormatterStyle)numberStyle {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:numberStyle];
    NSString *result = [formatter stringFromNumber:self];
    
    return result;
}

@end
