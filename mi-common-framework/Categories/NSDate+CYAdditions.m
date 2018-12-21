//
//  NSDate+JoyKit.m
//  ShopSNS
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "NSDate+CYAdditions.h"

NSString * const CYDateFormatDate = @"yyyy-MM-dd";
NSString * const CYDateFormatTime = @"HH:mm:ss";
NSString * const CYDateFormatDateAndTime = @"yyyy-MM-dd HH:mm";
NSString * const CYDateFormatTimestamp = @"yyyy-MM-dd HH:mm:ss";
NSString * const CYDateFormatISO8601 = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

@implementation NSDate (CYAdditons)

+ (NSDate *)dateFromString:(NSString *)string
{
	return [NSDate dateFromString:string withFormat:CYDateFormatISO8601];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	return date;
}

+ (NSDate *)dateFromTimestemp:(NSTimeInterval)timestemp {
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:timestemp/1000.0];
    return data;
}

- (NSTimeInterval)timestemp {
    return (long long)([self timeIntervalSince1970] * 1000);
}

- (NSString *)stringWithFormat:(NSString *)format
{
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string
{
	return [self stringWithFormat:CYDateFormatISO8601];
}

/* 
 Different NSDateFormatterStyle
 日期
 30/6/15
 30/6/2015
 30 de junio de 2015
 martes, 30 de junio de 2015
 时间
 10:38
 10:38:53
 10:38:53 GMT+8
 10:38:53 (Hora estándar de China)
*/
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]]];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

- (NSString *)gapString {
    NSString *dateString = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self toDate:[NSDate date] options:0];
    if (dateComponent.year > 0) {
        dateString = [NSString stringWithFormat:@"%@年前", @(dateComponent.year)];
    } else if (dateComponent.month > 0) {
        dateString = [NSString stringWithFormat:@"%@月前", @(dateComponent.month)];
    } else if (dateComponent.day > 0) {
        dateString = [NSString stringWithFormat:@"%@天前", @(dateComponent.day)];
    } else if (dateComponent.hour > 0) {
        dateString = [NSString stringWithFormat:@"%@小时前", @(dateComponent.hour)];
    } else if (dateComponent.minute >= 1) {
        dateString = [NSString stringWithFormat:@"%@分钟前", @(dateComponent.minute)];
    } else {
        dateString = @"刚刚";
    }
    
    return dateString;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDate *from;
    NSDate *to;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&from interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&to interval:NULL forDate:toDate];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:from toDate:to options:0];
    NSInteger days = difference.day;
    return days;
}

+ (NSInteger)yearFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDate *from;
    NSDate *to;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&from interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&to interval:NULL forDate:toDate];
    NSDateComponents *difference = [calendar components:NSCalendarUnitYear fromDate:from toDate:to options:0];
    NSInteger year = difference.year;
    return year;
}

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *todayComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    return dateComponent.year == todayComponent.year && dateComponent.month == todayComponent.month && dateComponent.day == todayComponent.day;
}

- (BOOL)isSameDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *dateComponent2 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return dateComponent.year == dateComponent2.year && dateComponent.month == dateComponent2.month && dateComponent.day == dateComponent2.day;
}

- (NSDate *)dayStartDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDate *date = [calendar dateFromComponents:dateComponent];
    return date;
}

- (NSDate *)dayEndDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    dateComponent.hour = 23;
    dateComponent.minute = 59;
    dateComponent.second = 59;
    NSDate *date = [calendar dateFromComponents:dateComponent];
    return date;
}

@end
