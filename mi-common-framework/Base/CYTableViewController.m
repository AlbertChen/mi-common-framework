//
//  CYRefreshViewController.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYTableViewController.h"
#import "CYConstants.h"

#define AUTO_REFRESH_INTERVAL   30 * 60 // 默认自动刷新时间

@interface CYTableViewController ()

@property (nonatomic, strong) UILabel *noMoreDataLabel;

@end

@implementation CYTableViewController

#pragma mark - Properties

- (UILabel *)noMoreDataLabel {
    if (_noMoreDataLabel == nil) {
        _noMoreDataLabel = [[UILabel alloc] initWithFrame:self.tableView.infiniteScrollingView.bounds];
        _noMoreDataLabel.text = NSLocalizedString(@"No more data",);
        _noMoreDataLabel.font = [UIFont boldSystemFontOfSize:14];
        _noMoreDataLabel.textColor = [UIColor darkGrayColor];
        _noMoreDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _noMoreDataLabel;
}

- (void)setPullRefreshEnabled:(BOOL)pullRefreshEnabled {
    _pullRefreshEnabled = pullRefreshEnabled;
    
    if (self.tableView.pullToRefreshView) {
        self.tableView.showsPullToRefresh = pullRefreshEnabled;
    }
}

- (void)setPullLoadMoreEnabled:(BOOL)pullLoadMoreEnabled {
    _pullLoadMoreEnabled = pullLoadMoreEnabled;
    
    if (self.tableView.infiniteScrollingView) {
        self.tableView.showsInfiniteScrolling = pullLoadMoreEnabled;
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.pullRefreshEnabled = YES;
    self.pullLoadMoreEnabled = YES;
    self.shouldAutoRefresh = YES;
    self.autoRefreshInterval = AUTO_REFRESH_INTERVAL;
}

- (void)dealloc
{
    [self.paginator cancel];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    if (self.stateView == nil && self.tableView != nil) {
        self.stateView = [[CYStateView alloc] initWithFrame:self.tableView.bounds];
        self.stateView.backgroundColor = [UIColor clearColor];
        self.stateView.state = CYStateViewStateNone;
        [self.view addSubview:self.stateView];
        
        self.stateView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.stateView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.stateView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.stateView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.stateView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self.view addConstraint:constraint];
    }
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    DEFINE_WEAK_PTR(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        [w_self handleRefresh];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [w_self handleLoadMore];
    }];
    self.tableView.infiniteScrollingView.enabled = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self autoRefreshIfNeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppearForTheFirstTime:(BOOL)animated {
    [super viewDidAppearForTheFirstTime:animated];
    
    if (self.paginator.constObjects.count == 0) {
        NSArray *cachedData = [self queryCachedData];
        if (cachedData.count > 0) {
            [self.paginator insertCustomObjects:cachedData appending:NO];
            [self updateDataSource];
            
            if (self.stateView.state == CYStateViewStateEmpty || self.stateView.state == CYStateViewStateError) {
                self.stateView.state = CYStateViewStateNone;
            }
        }
    }
    
    [self triggerRefresh];
}

- (void)stateViewTapped:(CYStateViewState)type {
    [self triggerRefresh];
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self autoRefreshIfNeed];
}

#pragma mark - Load Data

- (void)autoRefreshIfNeed {
    if (!self.isViewAppearedFirstTime && self.shouldAutoRefresh) {
        if (self.latestRefreshDate == nil || [[NSDate date] timeIntervalSinceDate:self.latestRefreshDate] >= self.autoRefreshInterval) {
            [self triggerRefresh];
        }
    }
}

- (NSArray *)queryCachedData {
    return nil;
}

- (void)triggerRefresh {
    if (self.paginator == nil || self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) return;
    
    if (!self.pullRefreshEnabled) {
        [self handleRefresh];
    } else {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        [self.tableView triggerPullToRefresh];
    }
}

- (void)handleRefresh {
    if (self.paginator == nil) return;
    
    if ([self.paginator isLoadingMore]) {
        [self.paginator cancel];
    }
    if (!self.paginator.isLoading) {
        if (self.pullRefreshEnabled) {
            self.stateView.state = CYStateViewStateNone;
        } else {
            self.stateView.state = CYStateViewStateLoading;
        }
        [self.paginator load:NO];
    }
}

- (void)handleLoadMore {
    if (!self.paginator.isLoading) {
        [self.paginator load:YES];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)updateDataSource {
    [self.paginator refreshConstObjects];
    [self.tableView reloadData];
}

#pragma mark - CYDataPaginatorDelegate

- (void)paginatorDidStartLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore {
    
}

- (void)paginatorDidFinishLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore {
    self.latestRefreshDate = [NSDate date];
    [self updateDataSource];
    
    if (!isMore) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        self.stateView.state = self.paginator.constObjects.count == 0 ? CYStateViewStateEmpty : CYStateViewStateNone;
    }
    
    if (self.pullLoadMoreEnabled) {
        [self.tableView.infiniteScrollingView stopAnimating];
        if ([self.paginator hasMore]) {
            self.tableView.infiniteScrollingView.enabled = YES;
            [self.noMoreDataLabel removeFromSuperview];
        } else {
            self.tableView.infiniteScrollingView.enabled = NO;
            [self.tableView.infiniteScrollingView addSubview:self.noMoreDataLabel];
            self.noMoreDataLabel.alpha = 0.0;
            [UIView animateWithDuration:1.5 animations:^{
                self.noMoreDataLabel.alpha = 1.0;
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.showsInfiniteScrolling = self.tableView.contentSize.height > self.tableView.bounds.size.height;
        });
    }
}

- (void)paginator:(CYDataPaginator *)paginator didFailLoadWithError:(NSError*)error isMore:(BOOL)isMore {
    if (!isMore) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        self.stateView.state = self.paginator.constObjects.count == 0 ? CYStateViewStateError : CYStateViewStateNone;
        // TODO: Show error message
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)paginatorDidCancelLoad:(CYDataPaginator *)paginator isMore:(BOOL)isMore {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paginator.constObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"This method should be overridden.");
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
