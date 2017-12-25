//
//  NSDictionary+CYAddtions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 28/06/2017.
//  Copyright © 2017 CYYUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYDataModel.h"

@interface NSDictionary (CYAdditions)

+ (instancetype)dictionaryWithString:(NSString *)string;
+ (instancetype)dictionaryWithDataModel:(CYDataModel *)dataModel;

@end
