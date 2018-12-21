//
//  CYMultiLineInputTableViewCell.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/5/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYInputTableViewCell.h"
#import "SZTextView.h"

@interface CYMultiLineInputTableViewCell : CYInputTableViewCell <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet SZTextView *textView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewLeadingC;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewTrailingC;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewTopC;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewBottomC;

+ (CGFloat)cellHeightWithText:(NSString *)text;

@end
