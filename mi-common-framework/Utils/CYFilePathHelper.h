//
//  NSBundle+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYFilePathHelper: NSObject

BOOL CYCreatePath(NSString *path);
BOOL CYCheckPathExsit(NSString *path, BOOL createIfNeeded);

NSString * CYCachesPath(void);
NSString * CYDocumentPath(void);
NSString * CYTempPath(void);

NSString * CYPathForDocumentsResource(NSString *relativePath, BOOL createIfNeeded);
NSString * CYPathForCachesResource(NSString *relativePath, BOOL createIfNeeded);
NSString * CYPathForTempResource(NSString *relativePath, BOOL createIfNeeded);

@end
