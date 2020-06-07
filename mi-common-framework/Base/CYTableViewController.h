//
//  CYRefreshViewController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYViewController.h"
#import "SVPullToRefresh.h"
#import "CYDataPaginator.h"

@interface CYTableViewController : CYViewController <UITableViewDataSource, UITableViewDelegate, CYDataPaginatorDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CYDataPaginator *paginator;
@property (nonatomic, assign) BOOL pullRefreshEnabled;
@property (nonatomic, assign) BOOL pullLoadMoreEnabled;

// Auto refresh: if YES will auto refresh in a special interval (autoRefreshInterval value) when view will appear.
@property (nonatomic, assign) BOOL shouldAutoRefresh;
@property (nonatomic, assign) NSTimeInterval autoRefreshInterval; // Default is 30 minutes.
@property (nonatomic, strong) NSDate *latestRefreshDate;

- (void)triggerRefresh;
- (void)handleRefresh;
- (void)handleLoadMore;

- (NSArray *)queryCachedData;
- (void)updateDataSource;

@end
