//
//  CYDataPaginator.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYDataPaginator;
@protocol CYDataPaginatorDelegate <NSObject>
@optional
- (NSString *)paginator:(CYDataPaginator *)paginator pageDate:(BOOL)isMore;
- (void)paginatorDidStartLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore;
- (void)paginatorDidFinishLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore;
- (void)paginator:(CYDataPaginator *)paginator didFailLoadWithError:(NSError*)error isMore:(BOOL)isMore;
- (void)paginatorDidCancelLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore;
@end

/**
 *	Base functional class for list mode.
 */
@interface CYDataPaginator : NSObject

@property (nonatomic, weak) id<CYDataPaginatorDelegate> delegate;

/**
 *	This property can be used in your table view. It's stable.
 *  If you want latest objects, you should invoke -refreshConstObjects.
 *  Default is nil.
 */
@property (nonatomic, readonly) NSArray *constObjects;
- (void)refreshConstObjects;

/**
 *	init method.
 */
- (id)initWithDelegate:(id<CYDataPaginatorDelegate>)delegate;

/**
 *	Set fetched result handler
 */
- (void)setResultHandler:(void (^)(CYDataPaginator *paginator, NSArray *list, BOOL isMore))resultHandler;

- (void)setExtraResultHandler:(void (^)(CYDataPaginator *paginator, id responseObject, BOOL isMore))extraHandler;

/**
 *	Insert your own object to objects
 */
- (void)insertCustomObjects:(NSArray *)objects appending:(BOOL)appending;

/**
 * Insert object to given index.
 */
- (void)insertObject:(id)object atIndex:(NSUInteger)idx;

/**
 * Remove all objects from objects
 */
- (void)removeAllObjects;

/**
 * Remove object from objects
 */
- (void)removeObject:(id)object;
- (void)removeObjects:(NSArray *)objects;

/**
 * Exchange object with index
 */
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

/**
 * Indicates that the data is in the process of loading.
 *
 * Default implementation returns NO.
 */
- (BOOL)isLoading;

/**
 * Indictes that is loading more data.
 * Defualt implementation returns NO;
 */
- (BOOL)isLoadingMore;

/**
 * Indicates that has more data.
 *
 * Default implementation returns YES.
 */
- (BOOL)hasMore;

/**
 * Loads the model.
 *
 * Default implementation does nothing.
 */
- (void)load:(BOOL)isMore;

/**
 * Cancels a load that is in progress.
 *
 * Default implementation does nothing.
 */
- (void)cancel;

@end
