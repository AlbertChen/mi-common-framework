//
//  CYImageInfiniteSlideView.m
//  ImageInfiniteSlideViewDemo
//
//  Created by Chen Yiliang on 6/30/15.
//  Copyright © 2015 Chen Yiliang. All rights reserved.
//

#import "CYImageInfiniteSlideView.h"
#import "UIImageView+WebCache.h"

IB_DESIGNABLE

@interface CYImageInfiniteSlideView () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *captionView;
@property (nonatomic, strong, readwrite) UILabel *captionLabel;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *autoSlideTimer;
@property (nonatomic, assign, readonly) NSUInteger numberOfImages;
@property (nonatomic, assign) IBInspectable CYImageInfiniteSlideViewPageControlPosition pageControlPosition;

@end

@implementation CYImageInfiniteSlideView

- (void)dealloc {
    [self stopAutoSlideTimer];
}

#pragma mark - Getters & Setters

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIView *)captionView {
    if (_captionView == nil) {
        _captionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 35.0)];
        _captionView.translatesAutoresizingMaskIntoConstraints = NO;
        _captionView.backgroundColor = [UIColor clearColor];
        _captionView.userInteractionEnabled = NO;
    }
    
    return _captionView;
}

- (UILabel *)captionLabel {
    if (_captionLabel == nil) {
        _captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _captionLabel.textColor = [UIColor whiteColor];
        _captionLabel.font = [UIFont systemFontOfSize:15.0];
        _captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _captionLabel;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.userInteractionEnabled = NO;
    }
    
    return _pageControl;
}

- (void)setShouldAutoSlide:(BOOL)shouldAutoSlide {
    if (_shouldAutoSlide == shouldAutoSlide) return;
    
    _shouldAutoSlide = shouldAutoSlide;
    [self startAutoSlideTimerIfNeed];
}

- (NSUInteger)currentPage {
    return self.pageControl.currentPage;
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    [self setCurrentPage:currentPage animated:NO];
}

- (NSUInteger)numberOfImages {
    return [self.dataSource numberOfImagesInSlideView:self];
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id<CYImageInfiniteSlideViewDataSource>)dataSource
                     delegate:(id<CYImageInfiniteSlideViewDelegate>)delegate {
    return [self initWithFrame:frame pageControlPosition:CYImageInfiniteSlideViewPageControlPositionRight dataSource:dataSource delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame
          pageControlPosition:(CYImageInfiniteSlideViewPageControlPosition)pageControlPosition
                   dataSource:(id<CYImageInfiniteSlideViewDataSource>)dataSource
                     delegate:(id<CYImageInfiniteSlideViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _dataSource = dataSource;
        _delegate = delegate;
        _pageControlPosition = pageControlPosition;
        
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    [self addSubview:self.scrollView];
    [self addSubview:self.captionView];
    [self.captionView addSubview:self.captionLabel];
    [self.captionView addSubview:self.pageControl];
    
    [self setupLayoutConstraints];
    [self reloadData];
}

- (void)setupLayoutConstraints {
    NSDictionary *views = @{ @"scrollView": self.scrollView,
                             @"captionView": self.captionView,
                             @"captionLabel": self.captionLabel,
                             @"pageControl": self.pageControl };
    
    CGFloat captionHeight = self.captionView.frame.size.height;
    CGFloat captionLeftMargin = 10.0;
    if ([self.delegate respondsToSelector:@selector(heightForCaptionInImageSlideView:)]) {
        captionHeight = [self.delegate heightForCaptionInImageSlideView:self];
    }
    if ([self.delegate respondsToSelector:@selector(leftMarginForCaptionInImageSlideVeiw:)]) {
        captionLeftMargin = [self.delegate leftMarginForCaptionInImageSlideVeiw:self];
    }
    NSDictionary *metrics = @{ @"captionHeight": @(captionHeight),
                               @"captionLeftMargin": @(captionLeftMargin) };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[captionView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[captionView(captionHeight)]|" options:0 metrics:metrics views:views]];
    
    if (self.pageControlPosition == CYImageInfiniteSlideViewPageControlPositionRight) {
        [self.captionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(captionLeftMargin)-[captionLabel]-(2)-[pageControl]-(8)-|" options:0 metrics:metrics views:views]];
        [self.captionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[captionLabel]|" options:0 metrics:metrics views:views]];
        [self.captionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageControl]|" options:0 metrics:metrics views:views]];
        
        [self.pageControl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.captionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(captionLeftMargin)-[captionLabel]-|" options:0 metrics:metrics views:views]];
        [self.captionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[captionLabel]|" options:0 metrics:metrics views:views]];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.captionView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.captionView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        
        [self.captionView addConstraints:@[centerXConstraint, centerYConstraint]];
    }
}

#pragma mark - Actions

- (void)imageViewTapped:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(imageInfiniteSlideView:didSelectImageAtPage:)]) {
        UIView *imageView = gestureRecognizer.view;
        NSInteger selectedPage = imageView.tag - 100;
        [self.delegate imageInfiniteSlideView:self didSelectImageAtPage:selectedPage];
    }
}

#pragma mark -

- (UIImageView *)imageViewWithIndex:(NSUInteger)index {
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = (index + 1) * frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.tag = 100 + index;
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [imageView addGestureRecognizer:tapGesture];
    
    if ([self.dataSource respondsToSelector:@selector(imageInfiniteSlideView:imageAtPage:)]) {
        imageView.image = [self.dataSource imageInfiniteSlideView:self imageAtPage:index];
    } else if ([self.dataSource respondsToSelector:@selector(imageInfiniteSlideView:imageURLAtPage:)]) {
        NSURL *url = [self.dataSource imageInfiniteSlideView:self imageURLAtPage:index];
        // TODO: Download image...
        UIImage *placeholderImage = nil;
        if ([self.delegate placeholderImageInImageSlideView:self]) {
            placeholderImage = [self.delegate placeholderImageInImageSlideView:self];
        }
        [imageView sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageTransformAnimatedImage];
    }
    
    return imageView;
}

- (void)currentPageChanged:(NSUInteger)page {
    if (page == NSNotFound) {
        self.pageControl.currentPage = 0;
        self.captionLabel.text = nil;
    } else {
        self.pageControl.currentPage = page;
        if ([self.delegate respondsToSelector:@selector(imageInfiniteSlideView:captionAtPage:)]) {
            self.captionLabel.text = [self.delegate imageInfiniteSlideView:self captionAtPage:page];
        }
    }
}

- (void)reloadData {
    [self stopAutoSlideTimer];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger imageCount = self.numberOfImages;
    self.pageControl.numberOfPages= imageCount;
    if (imageCount == 0) {
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        
        [self currentPageChanged:NSNotFound];
    } else if (imageCount == 1) {
        UIImageView *imageView = [self imageViewWithIndex:0];
        CGRect frame = imageView.frame;
        frame.origin.x = 0.0;
        imageView.frame = frame;
        [self.scrollView addSubview:imageView];
        
        self.scrollView.contentSize = imageView.frame.size;
        self.scrollView.contentOffset = CGPointZero;
        
        [self currentPageChanged:0];
    } else {
        for (NSInteger i = 0; i < imageCount; i++) {
            UIImageView *imageView = [self imageViewWithIndex:i];
            [self.scrollView addSubview:imageView];
        }
        
        UIImageView *lastImageView = [self imageViewWithIndex:imageCount - 1];
        CGRect frame = lastImageView.frame;
        frame.origin.x = 0;
        lastImageView.frame = frame;
        [self.scrollView addSubview:lastImageView];
        
        UIImageView *firstImageView = [self imageViewWithIndex:0];
        frame = firstImageView.frame;
        frame.origin.x = frame.size.width * (imageCount + 1);
        firstImageView.frame = frame;
        [self.scrollView addSubview:firstImageView];
        
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.width = (imageCount + 2) * frame.size.width;
        self.scrollView.contentSize = contentSize;
        
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = frame.size.width;
        self.scrollView.contentOffset = contentOffset;
        
        [self currentPageChanged:0];
    }
    
    [self startAutoSlideTimerIfNeed];
}

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated {
    [self stopAutoSlideTimer];
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    if (self.numberOfImages > 1) {
        contentOffset.x = (currentPage + 1) * self.scrollView.frame.size.width;
    } else {
        contentOffset = CGPointZero;
    }
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        [self currentPageChanged:currentPage];
        [self startAutoSlideTimerIfNeed];
    }];
}

#pragma mark - Auto Play

- (void)startAutoSlideTimerIfNeed {
    [self stopAutoSlideTimer];
    
    if (!self.shouldAutoSlide || self.numberOfImages <= 1) return;
    
    _autoSlideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoSlide) userInfo:nil repeats:NO];
}

- (void)stopAutoSlideTimer {
    if (self.autoSlideTimer != nil && [self.autoSlideTimer isValid]) {
        [self.autoSlideTimer invalidate];
    }
    self.autoSlideTimer = nil;
}

- (void)autoSlide {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x += self.scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoSlideTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger imageCount = self.numberOfImages;
    NSInteger index = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (index == 0) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = imageCount * scrollView.frame.size.width;
        scrollView.contentOffset = contentOffset;
        [self currentPageChanged:imageCount - 1];
    } else if (index == imageCount + 1) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = scrollView.frame.size.width;
        scrollView.contentOffset = contentOffset;
        [self currentPageChanged:0];
    } else {
        [self currentPageChanged:index - 1];
    }
    
    [self startAutoSlideTimerIfNeed];
}

@end
