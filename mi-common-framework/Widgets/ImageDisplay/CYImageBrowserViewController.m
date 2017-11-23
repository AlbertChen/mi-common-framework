//
//  ImageBrowserViewController.m
//
//  Created by Chen Yiliang on 4/29/15.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import "CYImageBrowserViewController.h"
#import "CYImageDisplayView.h"

@interface CYImageBrowserViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImage *placeholder;

@end

@implementation CYImageBrowserViewController

#pragma mark - Getters & Setters

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    [self layoutSubviews];
}

- (void)setBrowseIndex:(NSInteger)browseIndex
{
    if (browseIndex >= self.images.count) {
        browseIndex = self.images.count - 1;
    } else if (browseIndex < 0) {
        browseIndex = 0;
    }
    _browseIndex = browseIndex;
    
    if (_scrollView != nil) {
        CGPoint offset = _scrollView.contentOffset;
        offset.x = self.view.bounds.size.width * browseIndex;
        _scrollView.contentOffset = offset;
    }
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _zoomable = NO;
        _backButtonImage = nil;
        _browseIndex = 0;
    }
    
    return self;
}

- (instancetype)initWithImages:(NSArray *)images  placeholder:(UIImage *)placeholder delegate:(id<CYImageBrowserViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _images = images;
        _delegate = delegate;
        _placeholder = placeholder;
        
        self.title = [NSString stringWithFormat:@"1/%@", @(images.count)];
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<CYImageBrowserViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _images = imageURLs;
        _delegate = delegate;
        _placeholder = placeholder;
        
        self.title = [NSString stringWithFormat:@"1/%@", @(imageURLs.count)];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *backButtonImage = self.backButtonImage;
    if (backButtonImage == nil) {
        backButtonImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    if (self.editable) {
        UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonPressed:)];
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem;
    }
    
    if (_scrollView == nil) {
        [self.view addSubview:self.scrollView];
    }
}

- (void)viewWillLayoutSubviews
{
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.width = self.view.bounds.size.width * self.images.count;
    contentSize.height = self.view.bounds.size.height;
    self.scrollView.contentSize = contentSize;
    
    for (int i = 0; i < self.images.count; i++) {
        id image = self.images[i];
        CYImageDisplayView *displayView = nil;
        if ([image isKindOfClass:[UIImage class]]) {
            displayView  =[[CYImageDisplayView alloc] initWithFrame:self.view.bounds image:image];
        } else {
            displayView  =[[CYImageDisplayView alloc] initWithFrame:self.view.bounds placeholder:self.placeholder urlString:image];
        }
        
        displayView.tag = i + 100;
        displayView.userInteractionEnabled = self.zoomable;
        [displayView setBounceHorizontalEnabled:NO];
        
        CGRect frame = displayView.frame;
        frame.origin.x = self.view.bounds.size.width * i;
        displayView.frame = frame;
        [self.scrollView addSubview:displayView];
    }
    
    self.browseIndex = _browseIndex;
}

#pragma mark - UI Events

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteButtonPressed:(id)sender
{
    NSInteger index = self.browseIndex;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray:self.images];
    [imageArray removeObjectAtIndex:self.browseIndex];
    self.images = imageArray;
    self.browseIndex = index;
    self.title = [NSString stringWithFormat:@"%@/%@", @(_browseIndex + 1), @(self.images.count)];
    
    if ([self.delegate respondsToSelector:@selector(imageBrowserViewController:didDeleteImageAtIndex:)]) {
        [self.delegate imageBrowserViewController:self didDeleteImageAtIndex:index];
    }
    
    if (imageArray.count == 0) {
        [self backButtonPressed:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger) (floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > self.images.count - 1) index = self.images.count - 1;
    _browseIndex = index;
    self.title = [NSString stringWithFormat:@"%@/%@", @(_browseIndex + 1), @(self.images.count)];
    
    if (!self.zoomable) return;
    
    if (index > 0) {
        CYImageDisplayView *previousDisplayView = [self.scrollView viewWithTag:index - 1 + 100];
        [self updateDisplayViewIfNeed:previousDisplayView];
    }
    
    if (index < self.images.count - 1) {
        CYImageDisplayView *nextDisplayView = [self.scrollView viewWithTag:index + 1 + 100];
        [self updateDisplayViewIfNeed:nextDisplayView];
    }
}

#pragma mark - 

- (void)updateDisplayViewIfNeed:(CYImageDisplayView *)displayView {
    CGPoint startPoint = CGPointMake(displayView.frame.origin.x + 1.0, 0.0);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(displayView.frame) - 1.0, 0.0);
    CGRect visibleBounds = self.scrollView.bounds;
    if (!CGRectContainsPoint(visibleBounds, startPoint) && !CGRectContainsPoint(visibleBounds, endPoint)) {
        [displayView setZoomScale:1.0];
    }
}

@end
