//
//  CYObject.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYDataModel : NSObject <NSCopying>

+ (NSArray *)writeableProperties;
+ (NSArray *)objectsWithAttribuesArray:(NSArray *)attributesArray;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

- (void)updateAttributesWithModel:(CYDataModel *)model;

@end
