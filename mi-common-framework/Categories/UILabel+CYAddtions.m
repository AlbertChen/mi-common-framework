//
//  UILabel+Addtions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/26/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UILabel+CYAddtions.h"
#import <objc/runtime.h>

@implementation UILabel (Addtions)

- (NSString *)htmlText {
    return objc_getAssociatedObject(self, @selector(htmlText));
}

- (void)setHtmlText:(NSString *)htmlText {
    [self setHtmlText:htmlText withTextColor:self.textColor];
}

- (void)setHtmlText:(NSString *)htmlText withTextColor:(UIColor *)color {
    NSString *aHTML = nil;
    if ([htmlText isKindOfClass:[NSString class]]) {
        aHTML = htmlText;
    }
    objc_setAssociatedObject(self, @selector(htmlText), aHTML, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
