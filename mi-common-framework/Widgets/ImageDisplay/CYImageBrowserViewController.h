//
//  ImageBrowserViewController.h
//
//  Created by Chen Yiliang on 4/29/15.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYImageBrowserViewController;

@protocol CYImageBrowserViewControllerDelegate <NSObject>

- (void)imageBrowserViewController:(CYImageBrowserViewController *)viewController didDeleteImageAtIndex:(NSUInteger)index;

@end

@interface CYImageBrowserViewController : UIViewController

// Initial with UIImage objects
- (instancetype)initWithImages:(NSArray *)images  placeholder:(UIImage *)placeholder delegate:(id<CYImageBrowserViewControllerDelegate>)delegate;

// Initial with URL string objects
- (instancetype)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<CYImageBrowserViewControllerDelegate>)delegate;

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL zoomable;
@property (nonatomic, strong) UIImage *backButtonImage;

@property (nonatomic, assign) NSInteger browseIndex;
@property (nonatomic, weak) id<CYImageBrowserViewControllerDelegate> delegate;

@end
