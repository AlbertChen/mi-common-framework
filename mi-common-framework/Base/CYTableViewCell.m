//
//  CYTableViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYTableViewCell.h"

@interface CYTableViewCell ()

@property (nonatomic, weak) UIView *contentWidthView;

@end

@implementation CYTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setContentWidth:CGRectGetWidth([UIScreen mainScreen].bounds)];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setContentWidth:CGRectGetWidth([UIScreen mainScreen].bounds)];
}

- (void)setContentWidth:(CGFloat)contentWidth {
    if (self.contentWidthView != nil) {
        [self.contentWidthView removeFromSuperview];
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:view];
    
    NSDictionary *views = @{ @"contentView": self.contentView,
                             @"view": view };
    NSDictionary *metrics = @{ @"width": @(contentWidth) };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view(width)]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(10)]" options:0 metrics:metrics views:views]];
}

+ (CGFloat)cellHeight {
    return [[self class] cellHeightWithFixedRatio:NO];
}

+ (CGFloat)cellHeightWithFixedRatio:(BOOL)fixedRatio {
    return [[self class] cellHeightWithFixedRatio:fixedRatio constrainedToWidth:[UIScreen mainScreen].bounds.size.width];
}

+ (CGFloat)cellHeightWithFixedRatio:(BOOL)fixedRatio constrainedToWidth:(CGFloat)width {
    static CYTableViewCell *cell = nil;
    if (cell == nil  || ![cell isMemberOfClass:[self class]]) {
        cell = [[NSBundle mainBundle] loadNibNamed:[self cellIdentifier] owner:nil options:nil].firstObject;
    }
    
    CGFloat height = CGRectGetHeight(cell.frame);
    if (fixedRatio) {
        height = width * (height / CGRectGetWidth(cell.frame));
    }
    
    return height;
}

+ (CGFloat)fittingHeight {
    return [[self class] fittingHeightWithConstrainedToWidth:CGRectGetWidth([UIScreen mainScreen].bounds)];
}

+ (CGFloat)fittingHeightWithConstrainedToWidth:(CGFloat)width {
    return [[self class] cellFittingHeightWithContent:nil constrainedToWidth:width ignoreContent:YES];
}

+ (CGFloat)fittingHeightWithContent:(id)content {
    return [[self class] fittingHeightWithContent:content constrainedToWidth:CGRectGetWidth([UIScreen mainScreen].bounds)];
}

+ (CGFloat)fittingHeightWithContent:(id)content constrainedToWidth:(CGFloat)width {
    return [[self class] cellFittingHeightWithContent:content constrainedToWidth:width ignoreContent:NO];
}

+ (CGFloat)cellFittingHeightWithContent:(id)content constrainedToWidth:(CGFloat)width ignoreContent:(BOOL)ignore {
    static CYTableViewCell *cell = nil;
    if (cell == nil || ![cell isMemberOfClass:[self class]]) {
        cell = [[NSBundle mainBundle] loadNibNamed:[self cellIdentifier] owner:nil options:nil].firstObject;
        CGRect frame = cell.frame;
        frame.size.width = width;
        cell.frame = frame;
    }
    
    if (!ignore) {
        cell.content = content;
    }
    
    [cell.contentView setNeedsLayout];
    [cell.contentView updateConstraints];
    
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return ceilf(fittingSize.height);
}

+ (NSString *)cellIdentifier {
    return [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
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
