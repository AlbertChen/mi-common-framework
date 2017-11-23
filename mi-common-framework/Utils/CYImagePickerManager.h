//
//  ImagePickerManager.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/22/16.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef void (^ImagePickerCancelPickingMediaHandler)(void);
typedef void (^ImagePickerFinishPickingMediaHandler)(NSDictionary *info, UIImage *image);

typedef enum : NSUInteger {
    ImagePickerTypeCamera = 0,
    ImagePickerTypeMedia
} ImagePickerType;

@interface CYImagePickerManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (instancetype)sharedInstance;

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewControllr
                                          finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                          cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHanlder;
+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewControllr
                                          allowsEditing:(BOOL)allowsEditing
                                          finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                          cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHanlder;

- (BOOL)startFromViewController:(UIViewController *)controller
                       withType:(ImagePickerType)type
                  allowsEditing:(BOOL)allowsEditing
                  finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                  cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler;
- (BOOL)startFromViewController:(UIViewController *)controller
                       withType:(ImagePickerType)type
                  allowsEditing:(BOOL)allowsEditing
                       delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  allowsEditing:(BOOL)allowsEditing
                             usingFinishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                  cancalHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler;
- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  allowsEditing:(BOOL)allowsEditing
                                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

- (BOOL)startMediaBrowserFromViewController: (UIViewController *)controller
                              allowsEditing:(BOOL)allowsEditing
                         usingFinishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                              cancalHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler;
- (BOOL)startMediaBrowserFromViewController: (UIViewController *)controller
                              allowsEditing:(BOOL)allowsEditing
                              usingDelegate: (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;

@end
