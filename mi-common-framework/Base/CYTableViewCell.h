//
//  CYTableViewCell.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "MGSwipeTableCell.h"

typedef NS_ENUM(NSInteger, CYTableViewCellPosition) {
    CYTableViewCellPositionAlone = 0,
    CYTableViewCellPositionTop,
    CYTableViewCellPositionMiddle,
    CYTableViewCellPositionBottom
};

@interface CYTableViewCell : MGSwipeTableCell

+ (CGFloat)cellHeight;
+ (NSString *)cellIdentifier;

@property (nonatomic, assign) CYTableViewCellPosition position;
+ (CYTableViewCellPosition)positionForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end
