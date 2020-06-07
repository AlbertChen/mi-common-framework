//
//  NSNumber+CYAdditions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 2019/12/25.
//  Copyright © 2019 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CYAdditions)

// Round
- (NSString *)stringWithDecimalDigits:(NSUInteger)digits;
- (NSString *)stringWithDecimalDigits:(NSUInteger)digits shrinkTimes:(NSInteger)shrinkTimes;

// Not Round
- (NSString *)stringByCutOffWithDecimalDigits:(NSUInteger)digits;
- (NSString *)stringByCutOffWithDecimalDigits:(NSUInteger)digits shrinkTimes:(NSInteger)shrinkTimes;

// String with NSNumberFormatter
- (NSString *)stringWithFractionDigits:(NSUInteger)digits;
- (NSString *)stringWithNumberStyle:(NSNumberFormatterStyle)numberStyle;

@end
