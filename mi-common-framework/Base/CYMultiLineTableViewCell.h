//
//  CYMultiLineTableViewCell.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/26/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYTableViewCell.h"
#import "TTTAttributedLabel.h"

@interface CYMultiLineTableViewCell : CYTableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *multilineLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *multilineLabelLC; // Base contentView
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *multilineLabelTrailingC; // Base contentView
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *multilineLabelTopC; // Base contentView
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *multilineLabelBottomC; // Base contentView

+ (CGFloat)cellHeightWithText:(NSString *)text;

@property (nonatomic, weak) UINavigationController *navigationController;

- (void)iconImageViewTapped:(UIGestureRecognizer *)gestureRecognizer;
- (void)showImageWithURLString:(NSString *)URLString;

@end
