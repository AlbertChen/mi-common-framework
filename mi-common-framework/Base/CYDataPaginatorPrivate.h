//
//  CYDataPaginatorPrivate.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

typedef NS_ENUM(NSInteger, CYDataPaginatorRequestMethod) {
    CYDataPaginatorRequestMethodGet = 0,
    CYDataPaginatorRequestMethodPost
};

typedef NS_ENUM(NSInteger, CYDataPaginatorType) {
    CYDataPaginatorTypePageNo,
    CYDataPaginatorTypePageDate,
    CYDataPaginatorTypeOffsetCount,
    CYDataPaginatorTypeOffsetKey,
};

@interface CYDataPaginator (Private)

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

/**
 *	Configuration
 */
- (void)configPaginator;
- (NSString *)configPathWithParams:(NSMutableDictionary *)params isMore:(BOOL)isMore; // Use for RSTF api
- (void)configTask:(NSURLSessionDataTask **)task params:(NSMutableDictionary *)params;
- (void)configParams:(NSMutableDictionary *)params isMore:(BOOL)isMore;
- (id)debugDataMonitor;

/**
 *  Save data if need
 */
- (void)saveDataIfNeed:(NSArray *)result isMore:(BOOL)isMore;

/**
 * Notifies delegates that the model started to load.
 */
- (void)didStartLoad:(BOOL)isMore;

/**
 * Notifies delegates that the model finished loading
 */
- (void)didFinishLoad:(BOOL)isMore;

/**
 * Notifies delegates that the model failed to load.
 */
- (void)didFailLoadWithError:(NSError*)error isMore:(BOOL)isMore;

/**
 * Notifies delegates that the model canceled its load.
 */
- (void)didCancelLoad:(BOOL)isMore;

@end
