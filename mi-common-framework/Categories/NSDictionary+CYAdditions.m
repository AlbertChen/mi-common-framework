//
//  NSDictionary+CYAddtions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 28/06/2017.
//  Copyright © 2017 CYYUN. All rights reserved.
//

#import "NSDictionary+CYAdditions.h"

@implementation NSDictionary (CYAdditions)

+ (instancetype)dictionaryWithDataModel:(CYDataModel *)dataModel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *properties = [[dataModel class] writeableProperties];
    for (NSString *property in properties) {
        dict[property] = [dataModel valueForKey:property];
    }
    
    return [dict copy];
}

@end
