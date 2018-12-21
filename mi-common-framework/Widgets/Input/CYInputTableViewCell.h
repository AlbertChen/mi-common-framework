//
//  CYInputTableViewCell.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYTableViewCell.h"

@protocol CYInputTableViewCellDelegate;

@interface CYInputTableViewCell : CYTableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIImageView *accessoryImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *separatorViewHC;

@property (nonatomic, assign) NSInteger maxTextLength;
@property (nonatomic, weak) id<CYInputTableViewCellDelegate> inputDelegate;

@end

@protocol CYInputTableViewCellDelegate <NSObject>

@required
- (void)inputTableViewCell:(UITableViewCell *)cell viewDidBeginEditing:(UIView *)view;

@optional
- (void)inputTableViewCell:(UITableViewCell *)cell viewDidChange:(UIView *)view;
- (void)inputTableViewCell:(UITableViewCell *)cell viewDidEndEditing:(UIView *)view;

@end
