//
//  CYObject.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYDataModel.h"
#import "NSString+CYAdditions.h"
#import <objc/runtime.h>

@implementation CYDataModel

+ (NSArray *)writeableProperties {
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:0];
    Class c = [self class];
    while (c != [CYDataModel class]) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (int i = 0; i <outCount; i++) {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            NSString *attributesStr = [NSString stringWithUTF8String:property_getAttributes(property)];
            if ([attributesStr rangeOfString:@",R"].location == NSNotFound) {
                [propertyArray addObject:name];
            }
        }
        
        free(properties);
        c = class_getSuperclass(c);
    }
    
    return propertyArray;
}

+ (NSArray *)objectsWithAttribuesArray:(NSArray *)attributesArray {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *attributes in attributesArray) {
        id model = [[[self class] alloc] initWithAttributes:attributes];
        [objects addObject:model];
    }
    
    return objects;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (attributes == nil || ![attributes isKindOfClass:[NSDictionary class]]) return nil;
    
    self = [super init];
    if (self != nil) {
        [self updateAttributes:attributes];
    }
    
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    NSArray *properties = [[self class] writeableProperties];
    for (NSString *property in properties) {
        id value = attributes[property];
        if (value == nil) {
            continue;
        }
        if (value == [NSNull null]) {
            value = nil;
        }
        [self setValue:value forKey:property];
    }
}

- (void)updateAttributesWithModel:(CYDataModel *)model {
    NSArray *properties = [[self class] writeableProperties];
    for (NSString *property in properties) {
        if ([model respondsToSelector:NSSelectorFromString(property)]) {
            [self setValue:[model valueForKey:property] forKey:property];
        }
    }
}

- (id)copyWithZone:(nullable NSZone *)zone {
    id newProfile = [[[self class] alloc] init];
    for (NSString *property in [[self class] writeableProperties]) {
        [newProfile setValue:[self valueForKey:property] forKey:property];
    }
    
    return newProfile;
}

@end
