//
//  CYLogger.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYLogger.h"
#import "CYFilePathHelper.h"
#import "NSDate+CYAdditions.h"

/**
 If you set the log level to LOG_LEVEL_ERROR, then you will only see DDLogError statements.
 If you set the log level to LOG_LEVEL_WARN, then you will only see DDLogError and DDLogWarn statements.
 If you set the log level to LOG_LEVEL_INFO, you'll see Error, Warn and Info statements.
 If you set the log level to LOG_LEVEL_VERBOSE, you'll see all DDLog statements.
 If you set the log level to LOG_LEVEL_OFF, you won't see any DDLog statements.
 */
#if DEBUG
const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

static const NSTimeInterval kFileKeepTimeInterval = 7 * 24 * 60 * 60; // 7 days

@interface CYLogger ()

@property (nonatomic, strong) NSString *seriousLoggingfilePath;
@property (nonatomic, strong) NSFileHandle *seriousLoggingFileHandle;
@property (nonatomic, strong) dispatch_queue_t loggingQueue;

@end

@implementation CYLogger

+ (instancetype)sharedInstance {
    static CYLogger *logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[CYLogger alloc] init];
    });
    
    return logger;
}

- (id)init {
    if (self = [super init]) {
        _loggingQueue = dispatch_queue_create("com.petkit.DebugLogQueue", NULL);
        [self cleanDirectory];
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    }
    return self;
}

#pragma mark - Public

+ (NSString *)fileDirectory:(BOOL)createIfNeed {
    NSString *dir = CYPathForCachesResource([NSString stringWithFormat:@"%@", @"Logs"], createIfNeed);
    return dir;
}

+ (NSString *)filePathWithDate:(NSDate *)date createIfNeed:(BOOL)need {
    NSString *dir = [[self class] fileDirectory:need];
    NSString *filename = [date stringWithFormat:CYDateFormatDate];
    NSString *filePath = [dir stringByAppendingString:[NSString stringWithFormat:@"/%@.log",filename]];
    
    return filePath;
}

- (void)log:(CYLogType)type format:(NSString *)format, ...
{
    va_list args;
    if (format) {
        va_start(args, format);
        
        // Generate message
        NSString *logMsg = [[NSString alloc] initWithFormat:format arguments:args];
        
        // log in private GCD queue.
#if DEBUG
        if (/* DISABLES CODE */ (1)) {
#else
        if (type == CYLogTypeSerious) {
#endif
            [self interalLoggingTask:^{
                DDLogInfo(@"%@", logMsg);
                
                NSString *headerString = nil;
                if (!self.seriousLoggingFileHandle) {
                    NSString *filePath = [[self class] filePathWithDate:[NSDate date] createIfNeed:YES];
                    DDLogInfo(@"log file path: %@", filePath);
                    BOOL created = NO;
                    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
                        created = YES;
                    }
                    self.seriousLoggingfilePath = filePath;
                    self.seriousLoggingFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
                    if (created) {
                        // Add header
                        NSString *createTime = [[NSDate date] stringWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];
                        NSString *system = @"iOS";
                        NSString *platform = [UIDevice currentDevice].platform;
                        NSString *version = APP_VERSION;
                        headerString = [NSString stringWithFormat:@"============================================================\nCreate Date : %@\nSystem : %@\nPlatform Name : %@\nVersion : %@\n============================================================\n\n\n", createTime, system, platform, version];
                    }
                }
                [self.seriousLoggingFileHandle seekToEndOfFile];
                NSString *logMsgEx = [NSString stringWithFormat:@"[%@] %@\n", [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"], logMsg];
                if (headerString.length > 0) {
                    logMsgEx = [headerString stringByAppendingString:logMsgEx];
                }
                [self.seriousLoggingFileHandle writeData:[logMsgEx dataUsingEncoding:NSUTF8StringEncoding]];
                [self.seriousLoggingFileHandle synchronizeFile];
            }];
        } else {
            [self interalLoggingTask:^{
                if (type == CYLogTypeInfo) {
                    DDLogInfo(@"%@", logMsg);
                } else if (type == CYLogTypeWarn) {
                    DDLogWarn(@"%@", logMsg);
                } else if (type == CYLogTypeError) {
                    DDLogError(@"%@", logMsg);
                }
            }];
        }
            
        va_end(args);
    }
}

- (NSArray<NSString *> *)logFiles {
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[self class] fileDirectory:NO] error:NULL];
    return fileArray;
}
    
- (void)removeLogFile:(NSString *)filePath {
    if ([filePath isEqualToString:self.seriousLoggingfilePath]) {
        [self interalLoggingTask:^{
            if (self.seriousLoggingFileHandle) {
                [self.seriousLoggingFileHandle closeFile];
                self.seriousLoggingFileHandle = nil;
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        }];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
}
    
- (void)reset {
    [self interalLoggingTask:^{
        if (self.seriousLoggingFileHandle) {
            [self.seriousLoggingFileHandle closeFile];
            self.seriousLoggingFileHandle = nil;
        }
        
        NSString *filePath = [[self class] fileDirectory:NO];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }];
}
    
#pragma mark - Private
    
- (void)interalLoggingTask:(dispatch_block_t)block {
    dispatch_async(_loggingQueue, block);
}
    
- (void)cleanDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *logFiles = [self logFiles];
    NSString *directory = [[self class] fileDirectory:NO];
    for (NSString *file in logFiles) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:NULL];
        NSDate *createdDate = attributes.fileCreationDate;
        if (createdDate == nil || [[NSDate date] timeIntervalSinceDate:createdDate] > kFileKeepTimeInterval) {
            [fileManager removeItemAtPath:filePath error:NULL];
        }
    }
}
    
@end
