//
//  CYTableInputViewController.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/1/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYTableInputViewController.h"

@interface CYTableInputViewController ()

@end

@implementation CYTableInputViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.observerForKeyboard = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.firstResponderObject resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveButtonPressed:(id)sender {
    if ([self.firstResponderObject isFirstResponder]) {
        [self.firstResponderObject resignFirstResponder];
    }
}

#pragma mark - Keybord

- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}

- (void)scrollToCursorForView: (UIView *)view {
    CGRect cursorRect = CGRectZero;
    if ([view isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)view;
        cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    } else {
        cursorRect = view.bounds;
    }
    
    cursorRect = [self.tableView convertRect:cursorRect fromView:view];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    if ([self.firstResponderObject isFirstResponder]) {
        [self scrollToCursorForView:self.firstResponderObject];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Init cell
    return nil;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Do something
}

#pragma mark - CYInputTableViewCellDelegate

- (void)inputTableViewCell:(UITableViewCell *)cell viewDidBeginEditing:(UIView *)view {
    self.firstResponderObject = view;
    [self scrollToCursorForView:view];
}

- (void)inputTableViewCell:(UITableViewCell *)cell viewDidChange:(UIView *)view {
    // Do something
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self scrollToCursorForView:view];
}

- (void)inputTableViewCell:(UITableViewCell *)cell viewDidEndEditing:(UIView *)view {
    
}

@end
