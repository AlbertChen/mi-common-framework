//
//  CYTableViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYTableViewCell.h"

@implementation CYTableViewCell

+ (CGFloat)cellHeight {
    static UITableViewCell *cell = nil;
    if (cell == nil  || ![cell isMemberOfClass:[self class]]) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    
    return CGRectGetHeight(cell.frame);
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (CYTableViewCellPosition)positionForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    CYTableViewCellPosition position;
    NSUInteger cellCount = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
    if (cellCount == 1) {
        position = CYTableViewCellPositionAlone;
    } else if (indexPath.row == 0) {
        position = CYTableViewCellPositionTop;
    } else if (indexPath.row == cellCount - 1) {
        position = CYTableViewCellPositionBottom;
    } else {
        position = CYTableViewCellPositionMiddle;
    }
    
    return position;
}

@end
