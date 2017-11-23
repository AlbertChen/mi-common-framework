//
//  Reachabilty+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 5/23/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (CYAdditions)

BOOL is3GORGPRSReachable(void);
BOOL isWIFIReachable(void);
BOOL isNetworkReachable(void);

@end
