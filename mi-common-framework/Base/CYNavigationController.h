//
//  CYNavigationController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 6/7/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYNavigationController : UINavigationController <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL transitionInProcess;

@end
