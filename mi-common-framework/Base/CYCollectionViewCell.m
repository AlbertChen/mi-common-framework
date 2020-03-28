//
//  CYCollectionViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 08/12/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYCollectionViewCell.h"

@implementation CYCollectionViewCell

+ (CGFloat)cellHeight {
    static UICollectionViewCell *cell = nil;
    if (cell == nil  || ![cell isMemberOfClass:[self class]]) {
        cell = [[NSBundle mainBundle] loadNibNamed:[self cellIdentifier] owner:nil options:nil].firstObject;
    }
    
    return CGRectGetHeight(cell.frame);
}

+ (NSString *)cellIdentifier {
    return [NSStringFromClass([self class]) componentsSeparatedByString:@","].lastObject;
}

@end
