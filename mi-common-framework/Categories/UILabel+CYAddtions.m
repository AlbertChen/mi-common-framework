//
//  UILabel+Addtions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/26/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UILabel+CYAddtions.h"
#import <objc/runtime.h>

static void *UILabelHTMLKey = &UILabelHTMLKey;

@implementation UILabel (Addtions)

- (NSString *)html {
    return objc_getAssociatedObject(self, UILabelHTMLKey);
}

- (void)setHtml:(NSString *)html {
    [self setHtml:html withTextColor:self.textColor];
}

- (void)setHtml:(NSString *)html withTextColor:(UIColor *)color {
    NSString *aHTML = nil;
    if ([html isKindOfClass:[NSString class]]) {
        aHTML = html;
    }
    objc_setAssociatedObject(self, UILabelHTMLKey, aHTML, OBJC_ASSOCIATION_RETAIN);
    
    @try {
        NSError *error = nil;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[aHTML dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:&error];
        if (error != nil) {
            CYLogSerious(@"Failure to parse html, reason: %@", error.localizedDescription);
            self.text = aHTML;
        } else {
            [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
            
            NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
            [paragrahStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [attributedString length])];
            
            self.attributedText = attributedString;
        }
    } @catch (NSException *exception) {
        NSString *reason = [NSString stringWithFormat:@"%@-%@", exception.name, exception.reason];
        CYLogSerious(@"Failure to parse html, reason: %@", reason);
        self.text = aHTML;
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
