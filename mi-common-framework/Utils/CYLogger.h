//
//  CYLogger.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CocoaLumberjack.h"

typedef NS_ENUM(NSInteger, CYLogType){
    CYLogTypeInfo,
    CYLogTypeWarn,
    CYLogTypeError,
    // Dump all serious logs to serious.log file, and later upload it to server.
    CYLogTypeSerious
};

#define CYLog(frmt, ...) [[CYLogger sharedInstance] log:CYLogTypeInfo format:frmt, ##__VA_ARGS__]
#define CYLogInfo(frmt, ...) [[CYLogger sharedInstance] log:CYLogTypeInfo format:frmt, ##__VA_ARGS__]
#define CYLogWarn(frmt, ...) [[CYLogger sharedInstance] log:CYLogTypeWarn format:(@"%s [Line %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#define CYLogError(frmt, ...) [[CYLogger sharedInstance] log:CYLogTypeError format:(@"%s [Line %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#define CYLogSerious(frmt, ...) [[CYLogger sharedInstance] log:CYLogTypeSerious format:frmt, ##__VA_ARGS__]

extern const DDLogLevel ddLogLevel;

@interface CYLogger : NSObject

+ (instancetype)sharedInstance;

+ (NSString *)fileDirectory:(BOOL)createIfNeed;
+ (NSString *)filePathWithDate:(NSDate *)date createIfNeed:(BOOL)need;

// Common log method
- (void)log:(CYLogType)type format:(NSString *)format, ...;

- (NSArray<NSString *> *)logFiles;
- (void)removeLogFile:(NSString *)filePath;
- (void)reset;

@end
