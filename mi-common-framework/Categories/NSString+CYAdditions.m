//
//  NSString+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/28/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "NSString+CYAdditions.h"

@implementation NSString (CYAdditions)

+ (BOOL)isEmpty:(NSString *)string {
    return [string isEqual:[NSNull null]] || string == nil || [string isEqualToString:@""] || [string isEqualToString:@"null"];
}

- (BOOL)isMatchedRegExp:(NSString *)regExp {
    if ([NSString isEmpty:regExp]) return YES;
    
    NSError *error = nil;
    NSRegularExpression *rge = [[NSRegularExpression alloc] initWithPattern:regExp options:0 error:&error];
    NSTextCheckingResult *result = [rge firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return result.range.length == self.length;
}

+ (BOOL)isAvailableMobile:(NSString *)mobile {
    if ([self isEmpty:mobile]) return NO;
    
    return [mobile isMatchedRegExp:@"\\d{11}"];
}

+ (BOOL)isAvailableTelNumber:(NSString *)telNumber {
    if ([self isEmpty:telNumber]) return NO;
    
    return [telNumber isMatchedRegExp:@"\\d{11,18}"];
}

+ (BOOL)isAvailabelEmail:(NSString *)email {
    if ([self isEmpty:email]) return NO;
    
    return [email isMatchedRegExp:@"[0-9a-zA-Z\\._]+@[0-9a-zA-Z\\._]+\\.[0-9a-zA-Z\\._]+"];
}

+ (BOOL)isAvailableURLString:(NSString *)URLString {
    if ([self isEmpty:URLString]) return NO;
    
    NSString *pattern = @"(https|http)://[^\\s]+\\.(com|cn|com\\.cn|org|net|top|wang|cc|top|info|club|gov|edu)[^\\s]*";
    return [URLString isMatchedRegExp:pattern];
}

+ (NSComparisonResult)compareVersion:(NSString *)version1 toVersion:(NSString *)version2 {
    NSComparisonResult result = NSOrderedSame;
    if ([version1 isEqualToString:version2]) {
        result = NSOrderedSame;
    } else {
        NSArray *components1 = [version1 componentsSeparatedByString:@"."];
        NSArray *components2 = [version2 componentsSeparatedByString:@"."];
        if (components1.count == 0) {
            result = NSOrderedAscending;
        } else if (components2.count == 0) {
            result = NSOrderedDescending;
        } else {
            for (int i = 0; i < components1.count; i++) {
                NSInteger item1 = [components1[i] integerValue];
                NSInteger item2 = components2.count > i ? [components2[i] integerValue] : -1;
                if (item1 > item2) {
                    result = NSOrderedDescending;
                    break;
                } else if (item1 < item2) {
                    result = NSOrderedAscending;
                    break;
                }
            }
        }
    }
    
    return result;
}

- (NSString *)firstLetter {
    NSString *firstLetter = @"#";
    if ([NSString isEmpty:self]) {
        return firstLetter;
    }

    NSMutableString *mutableString = [NSMutableString stringWithString:[self substringToIndex:1]];
    CFMutableStringRef mutableStringRef = (__bridge CFMutableStringRef)mutableString;
    [self stringTransformToLatin:mutableStringRef];
    [self stringTransformStripCombiningMarks:mutableStringRef];

    NSString *letter = [[mutableString uppercaseString] substringToIndex:1];
    unichar capital = [letter characterAtIndex:0];
    if (capital >= 'A' && capital <= 'Z') {
        firstLetter = letter;
    }
    
    return firstLetter;
}

- (CFMutableStringRef)stringTransformToLatin:(CFMutableStringRef)mutableStringRef{
    
    CFStringTransform(mutableStringRef, nil, kCFStringTransformToLatin, NO);
    return mutableStringRef;
}

- (CFMutableStringRef)stringTransformStripCombiningMarks:(CFMutableStringRef)mutableStringRef{
    
    CFStringTransform(mutableStringRef, nil, kCFStringTransformStripCombiningMarks, NO);
    return mutableStringRef;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self sizeWithFont:font constrainedToSize:size defaultSize:CGSizeZero];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size defaultSize:(CGSize)defaultSize {
    CGSize result = CGSizeZero;
    if (font != nil) {
        @try {
            CGRect frame =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
            result = frame.size;
        } @catch (NSException *exception) {
            result = defaultSize;
        }
    }
    
    return result;
}

@end
