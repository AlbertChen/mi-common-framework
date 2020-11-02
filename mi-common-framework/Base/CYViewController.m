//
//  CYViewController.m
//  mi-common-framework
//
//  Created by Chen Yiliang on 4/20/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYViewController.h"
#import "CYConstants.h"
#import "UIBarButtonItem+CYAdditions.h"

@interface CYViewController ()

@property (nonatomic, assign) BOOL isViewAppearing;
@property (nonatomic, assign, readwrite) BOOL isViewAppearedFirstTime;

@end

@implementation CYViewController

#pragma mark - Lifecycle

- (void)dealloc {
    self.observerForKeyboard = NO;
    [self.dataTask cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isViewAppearedFirstTime = YES;
    
    if (self.navigationController.childViewControllers.count > 1) {
        NSString *backImage = self.backImage ?: @"nav_back";
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:backImage target:self selector:@selector(backButtonPressed:)];
    }
    
    if (self.stateView == nil) {
        self.stateView = [[CYStateView alloc] initWithFrame:self.view.bounds];
        self.stateView.backgroundColor = [UIColor clearColor];
        self.stateView.state = CYStateViewStateNone;
        self.stateView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.stateView];
    }
    
    [self.stateView setDetail:@"点击界面，重新加载" forState:CYStateViewStateEmpty];
    [self.stateView setDetail:@"点击界面，重新加载" forState:CYStateViewStateError];
    DEFINE_WEAK_PTR(self);
    [self.stateView setTapBlock:^(CYStateViewState state) {
        [w_self stateViewTapped:state];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL isFirstTime = self.isViewAppearedFirstTime;
    self.isViewAppearing = YES;
    self.isViewAppearedFirstTime = NO;
    
    if (isFirstTime) {
        [self viewDidAppearForTheFirstTime:animated];
    }
}

- (void)viewDidAppearForTheFirstTime:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.isViewAppearing = NO;
}

- (void)dismiss:(BOOL)animated {
    [self dismiss:animated completion:NULL];
}

- (void)dismiss:(BOOL)animated completion:(void (^)(void))completion {
    if (self.navigationController != nil) {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:animated];
        } else if (self.presentingViewController != nil) {
            [self dismissViewControllerAnimated:animated completion:completion];
        }
    } else {
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

#pragma mark - Actions

- (IBAction)backButtonPressed:(id)sender {
    [self dismiss:YES];
}

- (void)stateViewTapped:(CYStateViewState)type {
    
}

#pragma mark - Keyboard

- (void)setObserverForKeyboard:(BOOL)observerForKeyboard
{
    if (_observerForKeyboard != observerForKeyboard) {
        _observerForKeyboard = observerForKeyboard;
        
        if (_observerForKeyboard) {
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillShow:)
                                                         name: UIKeyboardWillShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillHide:)
                                                         name: UIKeyboardWillHideNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidShow:)
                                                         name: UIKeyboardDidShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidHide:)
                                                         name: UIKeyboardDidHideNotification
                                                       object: nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillHideNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidHideNotification
                                                          object: nil];
        }
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    //CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardDidShow:(NSNotification*)notification {
}

- (void)keyboardWillHide:(NSNotification*)notification {
}

- (void)keyboardDidHide:(NSNotification*)notification {
}

@end
