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

@implementation CYDataModelClassProperty

- (BOOL)isDataModel {
    return _dataModel;
}

@end

static NSArray * data_model_allowed_standard_property_types () {
    static NSArray *cy_data_model_allowed_standard_property_types = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cy_data_model_allowed_standard_property_types = @[
                                                          [NSString class], [NSNumber class], [NSDecimalNumber class], [NSArray class], [NSDictionary class], [NSNull class], //immutable JSON classes
                                                          [NSMutableString class], [NSMutableArray class], [NSMutableDictionary class] //mutable JSON classes
                                                          ];
    });
    
    return cy_data_model_allowed_standard_property_types;
}

@implementation CYDataModel

+ (NSArray *)writeableProperties {
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:0];
    Class c = [self class];
    while (c != [CYDataModel class]) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            CYDataModelClassProperty *p = [[CYDataModelClassProperty alloc] init];
            objc_property_t property = properties[i];
            p.name = [NSString stringWithUTF8String:property_getName(property)];
            
            NSString *attributesStr = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSArray *attributeItems = [attributesStr componentsSeparatedByString:@","];
            if ([attributeItems containsObject:@"R"]) {
                // ignore readonly property
                continue;
            }
            
            NSString *propertyType = nil;
            NSScanner *scanner = [NSScanner scannerWithString:attributesStr];
            
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            
            // Check if the property is an instance of a class
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
                Class type = NSClassFromString(propertyType);
                if (![data_model_allowed_standard_property_types() containsObject:type]) {
                    Class tc = type;
                    while (tc != [NSObject class]) {
                        if (tc == [CYDataModel class]) {
                            p.dataModel = YES;
                            break;
                        }
                        tc = class_getSuperclass(tc);
                    }
                    
                    if (!p.isDataModel) {
                        @throw [NSException exceptionWithName:@"CYDataModel type not allowed"
                                                       reason:[NSString stringWithFormat:@"Property type of %@.%@ is not supported by CYDataModel.", self.class, p.name]
                                                     userInfo:nil];
                    }
                }
                p.type = type;
                
                // Check the class type of array item
                if ([scanner scanString:@"<" intoString:NULL]) {
                    NSString *protocolName = nil;
                    [scanner scanUpToString:@">" intoString: &protocolName];
                    p.subitemType = NSClassFromString(protocolName);
                    
                    [scanner scanString:@">" intoString:NULL];
                }
            } else {
                @throw [NSException exceptionWithName:@"CYDataModel type not allowed"
                                               reason:[NSString stringWithFormat:@"Property type of %@.%@ is not supported by CYDataModel.", self.class, p.name]
                                             userInfo:nil];
            }
            
            [propertyArray addObject:p];
        }
        
        free(properties);
        c = class_getSuperclass(c);
    }
    
    return propertyArray;
}

+ (NSArray *)objectsWithAttribuesArray:(NSArray *)attributesArray {
    if ([attributesArray isEqual:[NSNull null]] || ![attributesArray isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *attributes in attributesArray) {
        id model = [[[self class] alloc] initWithAttributes:attributes];
        [objects addObject:model];
    }
    
    return [objects copy];
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if ([attributes isEqual:[NSNull null]] || ![attributes isKindOfClass:[NSDictionary class]]) return nil;
    
    self = [super init];
    if (self != nil) {
        [self updateAttributes:attributes];
    }
    
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    NSArray *properties = [[self class] writeableProperties];
    for (CYDataModelClassProperty *property in properties) {
        id value = attributes[property.name];
        if (value == nil || value == [NSNull null]) {
            continue;
        }
        
        if (property.isDataModel) {
            value = [[property.type alloc] initWithAttributes:value];
        } else if (property.type == [NSArray class] && property.subitemType) {
            value = [property.subitemType objectsWithAttribuesArray:value];
        } else if (property.type == [NSMutableString class]) {
            value = [NSMutableString stringWithString:value];
        } else if (property.type == [NSMutableArray class]) {
            if (property.subitemType) {
                value = [[property.subitemType objectsWithAttribuesArray:value] mutableCopy];
            } else {
                value = [value mutableCopy];
            }
        } else if (property.type == [NSMutableDictionary class]) {
            value = [value mutableCopy];
        }
        
        [self setValue:value forKey:property.name];
    }
}

- (void)updateAttributesWithModel:(CYDataModel *)model {
    NSArray *properties = [[self class] writeableProperties];
    for (CYDataModelClassProperty *property in properties) {
        if ([model respondsToSelector:NSSelectorFromString(property.name)]) {
            [self setValue:[model valueForKey:property.name] forKey:property.name];
        }
    }
}

- (id)copyWithZone:(nullable NSZone *)zone {
    id newModel = [[[self class] alloc] init];
    for (CYDataModelClassProperty *property in [[self class] writeableProperties]) {
        [newModel setValue:[self valueForKey:property.name] forKey:property.name];
    }
    
    return newModel;
}

@end
