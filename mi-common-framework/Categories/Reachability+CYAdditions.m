//
//  Reachabilty+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/23/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "Reachability+CYAdditions.h"

@implementation Reachability (CYAdditions)

BOOL isWWANReachable() {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability isReachableViaWWAN];
}

BOOL isWIFIReachable() {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability isReachableViaWiFi];
}

BOOL isNetworkReachable() {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability isReachable];
}

@end
