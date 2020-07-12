//
//  NSNumber+CYAdditions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 2019/12/25.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import "NSNumber+CYAdditions.h"

@implementation NSNumber (CYAdditions)

+ (NSNumber *)numberWithBinaryString:(NSString *)binaryString {
    if (!binaryString || [binaryString length] == 0) {
        return nil;
    }
    
    long long result = 0;
    for (int i = 0; i < binaryString.length; i++) {
        int num = [[binaryString substringWithRange:NSMakeRange(binaryString.length - 1 - i, 1)] intValue];
        result += num * powl(2, i);
    }
    
    return @(result);
}

- (NSString *)binaryString {
    NSString *result = @"" ;
    long long x = self.longLongValue;
    while (x > 0) {
        result = [[NSString stringWithFormat: @"%lld", x&1] stringByAppendingString:result];
        x = x >> 1;
    }
    
    return result;
}

+ (NSNumber *)numberWithHexString:(NSString *)hexString {
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0];
    [scanner scanHexLongLong:&result];
    
    return @(result);
}

- (NSString *)hexString {
    return [NSString stringWithFormat:@"%2llX", self.unsignedLongLongValue];
}

#pragma mark -

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
        if (num < 0) {
            num = ceil(times * num) / times;
        } else {
            num = floor(times * num) / times;
        }
        
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
