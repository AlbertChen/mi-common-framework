//
//  UIDevice+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/22/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "UIDevice+CYAdditions.h"
#import <sys/utsname.h>

@implementation UIDevice (CYAdditions)

- (NSString *)platform {
    // http://theiphonewiki.com/wiki/Models
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
