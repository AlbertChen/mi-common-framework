//
//  ProfileItem.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYProfileItem.h"

@implementation CYProfileItem

+ (NSArray *)profileItemsWithFileName:(NSString *)fileName content:(id)content {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *itemsDict = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *itemDict in itemsDict) {
        id item = [[[self class] alloc] initWithAttributes:itemDict content:content];
        [items addObject:item];
    }
    
    return items;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes content:(id)content {
    self = [super init];
    if (self != nil) {
        for (NSString *key in attributes.allKeys) {
            [self setValue:attributes[key] forKey:key];
        }
        [self setValueWithContent:content];
    }
    
    return self;
}

- (void)setValueWithContent:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.value = [content valueForKey:self.key];
    } else {
        if ([content respondsToSelector:NSSelectorFromString(self.key)]) {
            self.value = [content valueForKey:self.key];
        }
    }
}

- (NSString *)stringValue {
    NSString *result = nil;
    if ([self.value isKindOfClass:[NSString class]]) {
        result = self.value;
    } else {
        if (self.value != nil) {
            result = [NSString stringWithFormat:@"%@", self.value];
        }
    }
    
    return result;
}

- (NSString *)stringValueWithContent:(id)content {
    id value = nil;
    if ([content isKindOfClass:[NSDictionary class]]) {
        value = [content valueForKey:self.key];
    } else {
        if ([content respondsToSelector:NSSelectorFromString(self.key)]) {
            value = [content valueForKey:self.key];
        }
    }
    
    NSString *result = nil;
    if ([value isKindOfClass:[NSString class]]) {
        result = value;
    } else {
        if (value != nil) {
            result = [NSString stringWithFormat:@"%@", value];
        }
    }
    
    return result;
}

@end
