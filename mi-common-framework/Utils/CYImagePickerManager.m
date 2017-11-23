//
//  ImagePickerManager.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 8/22/16.
//  Copyright (c) 2015 Chen Yiliang. All rights reserved.
//

#import "CYImagePickerManager.h"

@interface CYImagePickerManager ()

@property (nonatomic, copy) ImagePickerFinishPickingMediaHandler finishHandler;
@property (nonatomic, copy) ImagePickerCancelPickingMediaHandler cancelHandler;

@end

@implementation CYImagePickerManager

+ (instancetype)sharedInstance
{
    static CYImagePickerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CYImagePickerManager alloc] init];
    });
    
    return manager;
}

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewControllr
                                          finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                          cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHanlder
{
    return [[self class] showActionSheetInViewController:viewControllr allowsEditing:NO finishHandler:finishHandler cancelHandler:cancelHanlder];
}

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewControllr
                                          allowsEditing:(BOOL)allowsEditing
                                          finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                          cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHanlder
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancelHanlder != nil) {
            cancelHanlder();
        }
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[CYImagePickerManager sharedInstance] startCameraControllerFromViewController:viewControllr allowsEditing:allowsEditing usingFinishHandler:finishHandler cancalHandler:cancelHanlder];
    }];
    UIAlertAction *pickPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[CYImagePickerManager sharedInstance] startMediaBrowserFromViewController:viewControllr allowsEditing:allowsEditing usingFinishHandler:finishHandler cancalHandler:cancelHanlder];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:pickPhotoAction];
    [viewControllr presentViewController:alertController animated:YES completion:NULL];
    
    return alertController;
}

#pragma mark - Image Picker

- (BOOL)startFromViewController:(UIViewController *)controller
                       withType:(ImagePickerType)type
                  allowsEditing:(BOOL)allowsEditing
                  finishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                  cancelHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler
{
    BOOL result = NO;
    if (type == ImagePickerTypeCamera) {
        result = [self startCameraControllerFromViewController:controller allowsEditing:allowsEditing usingFinishHandler:finishHandler cancalHandler:cancelHandler];
    } else {
        result = [self startMediaBrowserFromViewController:controller allowsEditing:allowsEditing usingFinishHandler:finishHandler cancalHandler:cancelHandler];
    }
    
    return result;
}

- (BOOL)startFromViewController:(UIViewController *)controller
                       withType:(ImagePickerType)type
                  allowsEditing:(BOOL)allowsEditing
                       delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    BOOL result = NO;
    if (type == ImagePickerTypeCamera) {
        result = [self startCameraControllerFromViewController:controller allowsEditing:UIAccessibilityAnnouncementNotification usingDelegate:delegate];
    } else {
        result = [self startMediaBrowserFromViewController:controller allowsEditing:allowsEditing usingDelegate:delegate];
    }
    
    return result;
}

- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  allowsEditing:(BOOL)allowsEditing
                             usingFinishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                                  cancalHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler
{
    self.finishHandler = finishHandler;
    self.cancelHandler = cancelHandler;
    return [self startCameraControllerFromViewController:controller allowsEditing:allowsEditing usingDelegate:self];
}

- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  allowsEditing:(BOOL)allowsEditing
                                  usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
//    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = allowsEditing;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController *)controller
                              allowsEditing:(BOOL)allowsEditing
                         usingFinishHandler:(ImagePickerFinishPickingMediaHandler)finishHandler
                              cancalHandler:(ImagePickerCancelPickingMediaHandler)cancelHandler
{
    self.finishHandler = finishHandler;
    self.cancelHandler = cancelHandler;
    return [self startMediaBrowserFromViewController:controller allowsEditing:allowsEditing usingDelegate:self];
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController *)controller
                              allowsEditing:(BOOL)allowsEditing
                              usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
//    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = allowsEditing;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.cancelHandler != nil) {
        self.cancelHandler();
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        //        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        if (self.finishHandler != nil) {
            self.finishHandler(info, imageToSave);
        }
    }
    
    // Handle a movied picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        //        NSString *moviePath = (NSString *)[[info objectForKey:
        //                                UIImagePickerControllerMediaURL] path];
        
        // Do something with the picked movie available at moviePath
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
