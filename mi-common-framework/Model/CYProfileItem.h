//
//  ProfileItem.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYProfileItem : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) NSString *keyboard;
@property (nonatomic, strong) NSString *selector;
@property (nonatomic, strong) NSNumber *textLength;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *accessoryImage;

@property (nonatomic, strong) id value;
@property (nonatomic, readonly) NSString *stringValue;

+ (NSArray *)profileItemsWithFileName:(NSString *)fileName content:(id)content;

- (instancetype)initWithAttributes:(NSDictionary *)attributes content:(id)content;

- (void)setValueWithContent:(id)content;
- (NSString *)stringValueWithContent:(id)content;

@end
