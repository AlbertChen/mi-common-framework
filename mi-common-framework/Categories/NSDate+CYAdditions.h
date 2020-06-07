//
//  NSDate+JoyKit.h
//  ShopSNS
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CYDateFormatDate; // yyyy-MM-dd
extern NSString * const CYDateFormatTime; // HH:mm:ss
extern NSString * const CYDateFormatDateAndTime; // yyyy-MM-dd HH:mm
extern NSString * const CYDateFormatTimestamp; // yyyy-MM-dd HH:mm:ss
extern NSString * const CYDateFormatISO8601; // yyyy-MM-dd'T'HH:mm:ss.SSSZ

@interface NSDate (CYAdditons)

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *)dateFromTimestemp:(NSTimeInterval)timestemp; // The unit of timestemp is ms
- (NSTimeInterval)timestemp;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSString *)gapString;

+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)yearFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)isToday;
- (BOOL)isSameDay:(NSDate *)date;
- (NSDate *)dayStartDate;
- (NSDate *)dayEndDate;

@end
