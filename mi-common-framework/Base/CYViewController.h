//
//  CYViewController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStateView.h"

@interface CYViewController : UIViewController

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, assign) BOOL navigationBarHidden;

#pragma mark - View Lifecycle

@property (nonatomic, assign, readonly) BOOL isViewAppearedFirstTime;
- (void)viewDidAppearForTheFirstTime:(BOOL)animated;

- (void)dismiss:(BOOL)animated;
- (void)dismiss:(BOOL)animated completion:(void (^)(void))completion;

- (IBAction)backButtonPressed:(id)sender;

#pragma mark - State View

@property (nonatomic, strong) IBOutlet CYStateView *stateView;

- (void)stateViewTapped:(CYStateViewState)type;

#pragma mark - Keyboard
/**
 *  Determines if the view controller will observer notification for the keyboard.
 */
@property (nonatomic, assign) BOOL observerForKeyboard;

/**
 *  CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
 NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
 NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 */
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardDidShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)keyboardDidHide:(NSNotification*)notification;

@end
