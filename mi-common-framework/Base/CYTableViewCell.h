//
//  CYTableViewCell.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYTableViewCellPosition) {
    CYTableViewCellPositionAlone = 0,
    CYTableViewCellPositionTop,
    CYTableViewCellPositionMiddle,
    CYTableViewCellPositionBottom
};

@interface CYTableViewCell : UITableViewCell

@property (nonatomic, strong) id content;

- (void)setContentWidth:(CGFloat)contentWidth;

+ (CGFloat)cellHeight;
+ (CGFloat)cellHeightWithFixedRatio:(BOOL)fixedRatio;
+ (CGFloat)cellHeightWithFixedRatio:(BOOL)fixedRatio constrainedToWidth:(CGFloat)width;

+ (CGFloat)fittingHeight;
+ (CGFloat)fittingHeightWithContent:(id)content;
+ (CGFloat)fittingHeightWithContent:(id)content constrainedToWidth:(CGFloat)width;

+ (NSString *)cellIdentifier;

@property (nonatomic, assign) CYTableViewCellPosition position;
+ (CYTableViewCellPosition)positionForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end
