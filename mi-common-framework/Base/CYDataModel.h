//
//  CYObject.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYDataModelClassProperty : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Class type;
@property (nonatomic, copy) Class subitemType; // Define mode: @property (nonatomic) NSArray<subitemType> array;
@property (nonatomic, assign, getter=isDataModel) BOOL dataModel; // Is kind of CYDateModel

@end

@interface CYDataModel : NSObject <NSCopying>

+ (NSArray<CYDataModelClassProperty *> *)writeableProperties;
+ (NSArray *)objectsWithAttribuesArray:(NSArray *)attributesArray;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

- (void)updateAttributesWithModel:(CYDataModel *)model;

@end
