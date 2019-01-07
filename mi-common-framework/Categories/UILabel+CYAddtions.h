//
//  UILabel+Addtions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/26/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addtions)

@property (nonatomic, strong) NSString *htmlText;

- (CGSize)boundingRectWithSize:(CGSize)size;

@end
