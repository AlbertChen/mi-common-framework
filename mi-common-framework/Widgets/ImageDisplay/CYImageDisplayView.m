//
//  ImageDisplayView.m
//
//  Created by Chen Yiliang on 3/16/15.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import "CYImageDisplayView.h"
#import "UIImageView+CYWebImage.h"

const static CGFloat kImageMaximumZoomScale = 4.0;

@interface CYImageDisplayView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CYImageDisplayView

#pragma mark - Class Methods

+ (instancetype)displayWithImage:(UIImage *)image inView:(UIView *)view
{
    CYImageDisplayView *displayView = [[CYImageDisplayView alloc] initWithFrame:view.bounds image:image];
    [displayView displayInView:view];
    return displayView;
}

+ (instancetype)displayWithPlaceholder:(UIImage *)placeholder urlString:(NSString *)urlString inView:(UIView *)view
{
    CYImageDisplayView *displayView = [[CYImageDisplayView alloc] initWithFrame:view.bounds placeholder:placeholder urlString:urlString];
    [displayView displayInView:view];
    return displayView;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.maximumZoomScale = kImageMaximumZoomScale;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_imageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.center = self.center;
        _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_indicatorView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self != nil) {
        [self setImage:image];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(UIImage *)placeholder urlString:(NSString *)urlString;
{
    self = [self initWithFrame:frame image:placeholder];
    if (self != nil) {
        if (placeholder == nil) {
            [self.indicatorView startAnimating];
        }
        
        __weak typeof(self) w_self = self;
        [_imageView setImageWithURLString:urlString placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [w_self.indicatorView stopAnimating];
            
//            if (image != nil && cacheType == SDImageCacheTypeNone) {
//                [w_self setImage:image];
//            }
            if (image != nil) {
                [w_self setImage:image];
            }
        }];
    }
    
    return self;
}

#pragma mark - View Configuration

- (void)setImage:(UIImage *)image
{
    _scrollView.zoomScale = 1.0;
    _imageView.image = image;
    
    float widthScale =  _scrollView.frame.size.width/image.size.width;
    if (image.size.width < _scrollView.frame.size.width) {
        widthScale = 1.0;
    }
    
    float heightScale = _scrollView.frame.size.height/image.size.height;
    if (image.size.height < _scrollView.frame.size.height) {
        heightScale = 1.0;
    }
    
    float scale = 0.0;
    float minScale = 0.0;
    
    if (widthScale < heightScale) {
        scale = widthScale;
        minScale = 1.0;
    } else {
        scale = widthScale;
        minScale = heightScale;
    }
    
    _scrollView.minimumZoomScale = minScale;
    _imageView.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float width = 0.0;
    float height = 0.0;
    if (_imageView.frame.size.width < _scrollView.frame.size.width) {
        width = _scrollView.frame.size.width;
    } else {
        width = _imageView.frame.size.width;
    }
    
    if (_imageView.frame.size.height < _scrollView.frame.size.height) {
        height = _scrollView.frame.size.height;
    } else {
        height = _imageView.frame.size.height;
    }
    
    _scrollView.contentSize = CGSizeMake(width, height);
    _imageView.center = CGPointMake(width/2, height/2);
}

- (void)setZoomScale:(CGFloat)zoomScale {
    [self.scrollView setZoomScale:zoomScale animated:NO];
}

- (void)setBounceHorizontalEnabled:(BOOL)enabled {
    self.scrollView.alwaysBounceHorizontal = enabled;
}

- (void)displayInView:(UIView *)view
{
    if (self.superview == nil) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:self];
    }
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self hide];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    float width = 0.0;
    float height = 0.0;
    
    if (_imageView.frame.size.width < scrollView.frame.size.width) {
        width = scrollView.frame.size.width;
        
        if (_imageView.frame.size.height < scrollView.frame.size.height) {
            height = scrollView.frame.size.height;
        } else {
            height = scrollView.contentSize.height;
        }
    } else {
        width = scrollView.contentSize.width;
        
        if (_imageView.frame.size.height < scrollView.frame.size.height) {
            height = scrollView.frame.size.height;
        } else {
            height = scrollView.contentSize.height;
        }
    }
    
    _imageView.center = CGPointMake(width/2, height/2);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
