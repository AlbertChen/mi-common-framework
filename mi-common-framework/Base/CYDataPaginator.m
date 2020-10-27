//
//  DMPaginator.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYDataPaginator.h"
#import "CYDataPaginatorPrivate.h"

@interface CYDataPaginator ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) CYDataPaginatorRequestMethod requestMethod;

/**
 *	List objects
 */
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) NSArray *constObjects;

/**
 *  Paging
 *  @example listQueryPath = @"result/posts/lastKey"; // offsetKeyQueryPath
 */
@property (nonatomic, strong) NSString *apiPath;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) NSString *orderBy;
@property (nonatomic, strong) NSString *offsetKey;
@property (nonatomic, strong) id offsetValue;
@property (nonatomic, strong) NSString *listQueryPath;
@property (nonatomic, strong) NSString *hasMoreQueryPath;
@property (nonatomic, strong) NSString *offsetKeyQueryPath;

@property (nonatomic, assign) CYDataPaginatorType paginatorType;

// Flags
@property (nonatomic, assign) BOOL hasMoreFlag;
@property (nonatomic, assign) BOOL loadingMoreFlag;
@property (nonatomic, assign) BOOL isErroredLastTime;

@property (nonatomic, copy) void(^resultHandler)(CYDataPaginator *paginator, NSArray *result, BOOL isMore);
@property (nonatomic, copy) void(^extraResultHandler)(CYDataPaginator *paginator, id responseObject, BOOL isMore);

@end

@implementation CYDataPaginator

- (id)initWithDelegate:(id<CYDataPaginatorDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        @synchronized(self.objects){
            self.objects = @[].mutableCopy;
        };
        self.hasMoreFlag = YES;
        self.loadingMoreFlag = NO;
        
        self.apiPath = nil;
        self.pageSize = 0;
        self.resultHandler = ^(CYDataPaginator *paginator, NSArray *result, BOOL isMore) {
            @synchronized(paginator.objects){
                [paginator.objects addObjectsFromArray:result];
            };
        };
        
        [self configPaginator];
    }
    return self;
}

- (void)dealloc
{
    [self cancel];
}

#pragma mark - Getter
- (BOOL)isLoading
{
    return (self.task && self.task.state == NSURLSessionTaskStateRunning);
}

- (BOOL)isLoadingMore {
    if (!self.loadingMoreFlag) {
        return NO;
    }
    
    return YES;
}

- (BOOL)hasMore
{
    if (!self.hasMoreFlag) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Action
- (void)load:(BOOL)isMore
{
//#if DEBUG
//    if ([self respondsToSelector:@selector(debugDataMonitor)]) {
//        id monitorData = [self debugDataMonitor];
//        if (monitorData) {
//            [self didStartLoad:isMore];
//            self.resultHandler(self, monitorData, isMore);
//            return;
//        }
//    }
//#endif
//    
//    [self cancel];
//    @synchronized(self.objects){
//        isMore = self.objects.count == 0 ? NO : isMore;
//    };
//    
//    NSMutableDictionary *params = @{}.mutableCopy;
//    // page size
//    if (self.pageSize > 0 && self.pageSize != NSNotFound) {
//        params[@"pageSize"] = @(self.pageSize).stringValue;
//    }
//    // order by
//    if (self.orderBy) {
//        params[@"orderBy"] = self.orderBy;
//    }
//    
//    // offset
//    if (self.paginatorType == CYDataPaginatorTypePageNo) {
//        // set page number
//        params[NSStringFromSelector(@selector(pageNo))] = isMore ? @(self.pageNo + 1) : @(1);
//    } else if (self.paginatorType == CYDataPaginatorTypePageDate) {
//        NSString *date = nil;
//        if ([self.delegate respondsToSelector:@selector(paginator:pageDate:)]) {
//            date = [self.delegate paginator:self pageDate:isMore];
//        }
//        params[@"pageDate"] = date ?: @"";
//    } else if (self.paginatorType == CYDataPaginatorTypeOffsetCount) {
//        @synchronized(self.objects){
//            params[self.offsetKey] = isMore ? @(self.objects.count) : @(0);
//        };
//    } else {
//        params[self.offsetKey] = isMore ? (self.offsetValue ? self.offsetValue : @"") : @"";
//    }
//    // custom
//    NSString *path = nil;
//    if ([self respondsToSelector:@selector(configPathWithParams:isMore:)]) {
//        path = [self configPathWithParams:params isMore:isMore];
//    }
//    if ([self respondsToSelector:@selector(configParams:isMore:)]) {
//        [self configParams:params isMore:isMore];
//    }
//    
//    DEFINE_WEAK_PTR(self);
//    void (^success)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
//        // list
//        NSArray *list = responseObject;
//        if (w_self.listQueryPath) {
//            NSArray *paths = [w_self.listQueryPath componentsSeparatedByString:@"/"];
//            for (id path in paths) {
//                list = [list valueForKey:path];
//            }
//            if ([list isEqual:[NSNull null]]) {
//                list = [NSArray array];
//            }
//        }
//        
//        if (w_self.paginatorType == CYDataPaginatorTypePageNo) {
//            w_self.pageNo = w_self.loadingMoreFlag ? w_self.pageNo + 1 : 1;
//        } else {
//            // offsetValue
//            if (w_self.offsetKeyQueryPath) {
//                id offsetValue = responseObject;
//                NSArray *paths = [w_self.offsetKeyQueryPath componentsSeparatedByString:@"/"];
//                for (id path in paths) {
//                    offsetValue = [offsetValue valueForKey:path];
//                }
//                if (offsetValue) {
//                    w_self.offsetValue = offsetValue;
//                }
//            }
//        }
//        
//        // remove all object first
//        if (!isMore) {
//            @synchronized(w_self.objects){
//                [w_self.objects removeAllObjects];
//            }
//        }
//        // set flag
//        if (w_self.hasMoreQueryPath != nil) {
//            id isEnd = responseObject;
//            NSArray *paths = [w_self.hasMoreQueryPath componentsSeparatedByString:@"/"];
//            for (id path in paths) {
//                isEnd = [isEnd valueForKey:path];
//            }
//            if (isEnd && ![isEnd isEqual:[NSNull null]] && [isEnd isKindOfClass:[NSNumber class]]) {
//                w_self.hasMoreFlag = ![isEnd boolValue];
//            }
//        } else {
//            w_self.hasMoreFlag = (list.count > 0 && list.count >= w_self.pageSize);
//        }
//        // extra result handler
//        if (w_self.extraResultHandler != nil) {
//            w_self.extraResultHandler(w_self, responseObject, isMore);
//        }
//        // customization
//        if (w_self.resultHandler != nil) {
//            w_self.resultHandler(w_self, list, isMore);
//        }
//        // save data if need
//        [w_self saveDataIfNeed:list isMore:isMore];
//        
//        [w_self didFinishLoad:isMore];
//    };
//    
//    void (^failure)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
//        if ([error code] == NSURLErrorCancelled) {
//            [w_self didCancelLoad:w_self.loadingMoreFlag];
//        } else {
//            [w_self didFailLoadWithError:error isMore:isMore];
//        }
//    };
//    
//    if (self.requestMethod == CYDataPaginatorRequestMethodPost) {
//        self.task = [NSURLSessionDataTask doPOSTTaskWithURLString:path != nil ? path : self.apiPath parameters:path != nil ? nil : params success:success failure:failure];
//    } else {
//        self.task = [NSURLSessionDataTask doGETTaskWithURLString:path != nil ? path : self.apiPath parameters:path != nil ? nil : params success:success failure:failure];
//    }
//    
//    [self didStartLoad:isMore];
}

- (void)cancel
{
    if ([self isLoading]) {
        [self.task cancel];
        self.task = nil;
        [self didCancelLoad:self.loadingMoreFlag];
    }
}

- (void)refreshConstObjects
{
    @synchronized(self.objects){
        if (!self.objects) {
            self.constObjects = @[];
            return;
        }
        self.constObjects = self.objects.copy;
    };
}

- (void)insertCustomObjects:(NSArray *)objects appending:(BOOL)appending
{
    if (objects.count == 0) {
        return;
    }
    
    @synchronized(self.objects){
        if (self.objects.count == 0) {
            [self.objects addObjectsFromArray:objects];
            return;
        }
    
        if (appending) {
            [self.objects addObjectsFromArray:objects];
        } else {
            NSMutableArray *newObjects = objects.mutableCopy;
            [newObjects addObjectsFromArray:self.objects];
            self.objects = newObjects;
        }
    };
}

- (void)insertObject:(id)object atIndex:(NSUInteger)idx {
    @synchronized (self.objects) {
        if (idx <= self.objects.count) {
            [self.objects insertObject:object atIndex:idx];
        }
    }
}

- (void)removeAllObjects
{
    @synchronized(self.objects){
        [self.objects removeAllObjects];
    }
}

- (void)removeObject:(id)object
{
    if (!object || self.objects.count == 0) {
        return;
    }
    @synchronized(self.objects){
        [self.objects removeObject:object];
    }
}

- (void)removeObjects:(NSArray *)objects
{
    if (!objects || self.objects.count == 0) {
        return;
    }
    @synchronized(self.objects){
        [self.objects removeObjectsInArray:objects];
    }
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    @synchronized (self.objects) {
        if (idx1 < self.objects.count && idx2 < self.objects.count) {
            [self.objects exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    }
}

#pragma mark - Process

- (void)saveDataIfNeed:(NSArray *)result isMore:(BOOL)isMore
{
    
}

- (void)didStartLoad:(BOOL)isMore
{
    self.loadingMoreFlag = isMore;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginatorDidStartLoad:isMore:)]) {
        [self.delegate paginatorDidStartLoad:self isMore:isMore];
    }
}

- (void)didFinishLoad:(BOOL)isMore
{
    self.loadingMoreFlag = NO;
    self.isErroredLastTime = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginatorDidFinishLoad:isMore:)]) {
        [self.delegate paginatorDidFinishLoad:self isMore:isMore];
    }
}

- (void)didFailLoadWithError:(NSError*)error isMore:(BOOL)isMore
{
    self.loadingMoreFlag = NO;
    self.isErroredLastTime = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginator:didFailLoadWithError:isMore:)]) {
        [self.delegate paginator:self didFailLoadWithError:error isMore:isMore];
    }
}

- (void)didCancelLoad:(BOOL)isMore
{
    self.loadingMoreFlag = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginatorDidCancelLoad:isMore:)]) {
        [self.delegate paginatorDidCancelLoad:self isMore:isMore];
    }
}

@end
