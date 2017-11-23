//
//  CYInputTableViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYInputTableViewCell.h"

@implementation CYInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textField.delegate = self;
    self.separatorViewHC.constant = 1.0 / [UIScreen mainScreen].scale;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.inputDelegate respondsToSelector:@selector(inputTableViewCell:viewDidBeginEditing:)]) {
        [self.inputDelegate inputTableViewCell:self viewDidBeginEditing:textField];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    if (textField.markedTextRange == nil && self.maxTextLength > 0 && textField.text.length >= self.maxTextLength && string.length > 0) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {        
    if ([self.inputDelegate respondsToSelector:@selector(inputTableViewCell:viewDidEndEditing:)]) {
        [self.inputDelegate inputTableViewCell:self viewDidEndEditing:textField];
    }
}

#pragma mark - Notification

- (void)textDidChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField.delegate == nil) return;
    
    if (self.maxTextLength > 0 && !textField.markedTextRange && textField.text.length > self.maxTextLength) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.maxTextLength)];
    }
}

@end
