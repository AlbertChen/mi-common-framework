//
//  UIImage+Additions.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 16/4/28.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYAdditions)

/**
 * Ruturn a image which orientation is up
 */
- (UIImage *)fixOrientation;

/**
 *  Resize methods.
 *
 *  @param dstSize boundingSize
 *
 *  @return resized image
 *  @seealso https://github.com/uzysjung/UzysImageCropper
 */
- (UIImage *)imageResizedToSize:(CGSize)dstSize;

/**
 * According to structure solid color in color images
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha;

/**
 * Compress image, default compressed size is less than 300KB.
 */
- (NSData *)compressedData;

- (NSData *)compressedDataWithLimit:(long)limit;

@end
