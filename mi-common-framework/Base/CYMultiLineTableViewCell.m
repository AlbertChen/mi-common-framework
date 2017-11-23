//
//  CYMultiLineTableViewCell.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/26/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYMultiLineTableViewCell.h"
#import "CYWebViewController.h"
#import "CYImageDisplayView.h"

#define TEXT_LINK_COLOR             [UIColor colorWithRed:0.0/255 green:160.0/255 blue:254.0/255 alpha:1.0]
#define TEXT_LINK_COLOR_HIGHLIGHT   [UIColor colorWithRed:145.0/255 green:230.0/255 blue:254.0/255 alpha:1.0]

@implementation CYMultiLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.multilineLabel.numberOfLines = 0;
    self.multilineLabel.delegate = self;
    self.multilineLabel.userInteractionEnabled = YES;
    self.multilineLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.multilineLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.multilineLabel.linkAttributes = @{ (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO],
                                            (NSString *)kCTForegroundColorAttributeName: TEXT_LINK_COLOR };
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[TEXT_LINK_COLOR_HIGHLIGHT CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.multilineLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTapped:)];
    [self.iconImageView addGestureRecognizer:tapGesture];
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    CGFloat height = 0.0;
    static CYMultiLineTableViewCell *cell = nil;
    if (cell == nil || ![cell isKindOfClass:[self class]]) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    
    if (text.length == 0) {
        height = cell.frame.size.height;
    } else {
        CGFloat multiLineLabelWidth = [UIScreen mainScreen].bounds.size.width - cell.multilineLabelLC.constant - cell.multilineLabelTrailingC.constant;
        cell.multilineLabel.text = text;
        CGSize fitSize = [cell.multilineLabel sizeThatFits:CGSizeMake(multiLineLabelWidth, CGFLOAT_MAX)];
        height = cell.multilineLabelTopC.constant + fitSize.height + cell.multilineLabelBottomC.constant;
        height = height > cell.frame.size.height ? ceilf(height) : cell.frame.size.height;
    }
    
    return height;
}

- (void)iconImageViewTapped:(UIGestureRecognizer *)gestureRecognizer {
    [self showImageWithURLString:nil];
}

- (void)showImageWithURLString:(NSString *)URLString {
    [CYImageDisplayView displayWithPlaceholder:self.iconImageView.image urlString:URLString inView:self.window];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    CYWebViewController *webViewController = [[CYWebViewController alloc] initWithObject:url.absoluteString delegate:nil];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self attributedLabel:label didSelectLinkWithURL:url];
    }];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (url.absoluteString != nil) {
            [[UIPasteboard generalPasteboard] setString:url.absoluteString];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:openAction];
    [alertController addAction:copyAction];
    [self.navigationController presentViewController:alertController animated:YES completion:NULL];
}

@end
