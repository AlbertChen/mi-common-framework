//
//  NSString+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/28/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYAdditions)

+ (BOOL)isEmpty:(NSString *)string;

- (BOOL)isMatchedRegExp:(NSString *)regExp;
+ (BOOL)isAvailableMobile:(NSString *)mobile;
+ (BOOL)isAvailableTelNumber:(NSString *)telNumber;
+ (BOOL)isAvailabelEmail:(NSString *)email;
+ (BOOL)isAvailableURLString:(NSString *)URLString;

+ (NSComparisonResult)compareVersion:(NSString *)version1 toVersion:(NSString *)version2;

- (NSString *)firstLetter;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size defaultSize:(CGSize)defaultSize;

@end
