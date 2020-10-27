//
//  ViewController.m
//  CommonFrameworkDemo
//
//  Created by Chen Yiliang on 2020/10/27.
//  Copyright © 2020 Chen Yiliang. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+CYWebImage.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImageWithURLString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603818892415&di=1c54dfa1b667c130696d92a32f40c6be&imgtype=0&src=http%3A%2F%2Fimg.ewebweb.com%2Fuploads%2F20190403%2F14%2F1554274760-nBvxNSCJHh.jpg" placeholderImage:nil];
}


@end
