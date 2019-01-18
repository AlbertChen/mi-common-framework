//
//  NSDictionary+CYAddtions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 28/06/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "NSDictionary+CYAdditions.h"

@implementation NSDictionary (CYAdditions)

+ (instancetype)dictionaryWithString:(NSString *)string {
    NSDictionary *result = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        NSError *error = nil;
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"JSON Serializztion error: %@", error);
        }
        
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            result = JSON;
        }
    }
    
    return result;
}

+ (instancetype)dictionaryWithDataModel:(CYDataModel *)dataModel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *properties = [[dataModel class] writeableProperties];
    for (CYDataModelClassProperty *property in properties) {
        dict[property.name] = [dataModel valueForKey:property.name];
    }
    
    return [dict copy];
}

@end
