//
//  CYMultiLineInputTableViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYMultiLineInputTableViewCell.h"
#import "UIView+CYAdditions.h"

@implementation CYMultiLineInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    static CYMultiLineInputTableViewCell *cell = nil;
    if (cell == nil || ![cell isKindOfClass:[self class]])  {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    
    cell.textView.text = text;
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - cell.textViewLeadingC.constant - cell.textViewTrailingC.constant;
    CGSize fitSize = [cell.textView sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    CGFloat height = cell.textViewTopC.constant + fitSize.height + cell.textViewBottomC.constant;
    height = height > cell.frame.size.height ? ceilf(height) : cell.frame.size.height;
    
    return height + 1.0;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(inputTableViewCell:viewDidBeginEditing:)]) {
        [self.inputDelegate inputTableViewCell:self viewDidBeginEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (self.maxTextLength > 0 && textView.text.length >= self.maxTextLength && text.length > 0) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.maxTextLength > 0 && !textView.markedTextRange && textView.text.length > self.maxTextLength) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, self.maxTextLength)];
    }
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(inputTableViewCell:viewDidChange:)]) {
        [self.inputDelegate inputTableViewCell:self viewDidChange:textView];
    }
}

@end
