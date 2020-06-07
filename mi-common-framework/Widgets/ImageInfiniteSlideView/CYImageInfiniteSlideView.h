//
//  CYImageInfiniteSlideView.h
//  ImageInfiniteSlideViewDemo
//
//  Created by Chen Yiliang on 6/30/15.
//  Copyright © 2015 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYImageInfiniteSlideViewPageControlPosition) {
    CYImageInfiniteSlideViewPageControlPositionRight,
    CYImageInfiniteSlideViewPageControlPositionCenter
};

@protocol CYImageInfiniteSlideViewDataSource, CYImageInfiniteSlideViewDelegate;

@interface CYImageInfiniteSlideView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id<CYImageInfiniteSlideViewDataSource>)dataSource
                     delegate:(id<CYImageInfiniteSlideViewDelegate>)delegate;
- (instancetype)initWithFrame:(CGRect)frame
          pageControlPosition:(CYImageInfiniteSlideViewPageControlPosition)pageControlPosition
                   dataSource:(id<CYImageInfiniteSlideViewDataSource>)dataSource
                     delegate:(id<CYImageInfiniteSlideViewDelegate>)delegate;

@property (nonatomic, weak) IBOutlet id<CYImageInfiniteSlideViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<CYImageInfiniteSlideViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *captionView;
@property (nonatomic, strong, readonly) UILabel *captionLabel;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL shouldAutoSlide;
@property (nonatomic, assign) NSUInteger currentPage;

- (void)reloadData;
- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;

@end

@protocol CYImageInfiniteSlideViewDataSource <NSObject>

@required
- (NSUInteger)numberOfImagesInSlideView:(CYImageInfiniteSlideView *)slideView;

@optional
- (UIImage *)imageInfiniteSlideView:(CYImageInfiniteSlideView *)slideView imageAtPage:(NSUInteger)page;
- (NSURL *)imageInfiniteSlideView:(CYImageInfiniteSlideView *)slideView imageURLAtPage:(NSUInteger)page;

@end

@protocol CYImageInfiniteSlideViewDelegate <NSObject>

@optional
- (CGFloat)heightForCaptionInImageSlideView:(CYImageInfiniteSlideView *)slideView;
- (CGFloat)leftMarginForCaptionInImageSlideVeiw:(CYImageInfiniteSlideView *)slideView;
- (UIImage *)placeholderImageInImageSlideView:(CYImageInfiniteSlideView *)sliderView;
- (NSString *)imageInfiniteSlideView:(CYImageInfiniteSlideView *)slideView captionAtPage:(NSUInteger)page;

- (void)imageInfiniteSlideView:(CYImageInfiniteSlideView *)slideView didSelectImageAtPage:(NSUInteger)page;

@end
