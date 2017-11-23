//
//  Reachabilty+Additions.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/23/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "Reachability+CYAdditions.h"

@implementation Reachability (CYAdditions)

BOOL is3GORGPRSReachable() {
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN;
}

BOOL isWIFIReachable() {
    return [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi;
}

BOOL isNetworkReachable() {
    return is3GORGPRSReachable() || isWIFIReachable();
}

@end
