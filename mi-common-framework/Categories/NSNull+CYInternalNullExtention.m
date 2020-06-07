//
//  NSNull+InternalNullExtention.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 16/5/19.
//  Copyright © 2016年 Chen Yiliang. All rights reserved.
//

#import "NSNull+CYInternalNullExtention.h"

#define NSNullObjects @[@"",@0,@{},@[]]

@implementation NSNull (CYInternalNullExtention)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            return object;
        }
    }
    
    return nil;
}

@end
