//
//  UINavigationBar+CYAdditions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 13/10/2017.
//  Copyright © 2017 CYYUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (CYAdditions)

@property (nonatomic, readonly) UIView *contentView;

- (void)hidenSeparator:(BOOL)hiden;

@end
