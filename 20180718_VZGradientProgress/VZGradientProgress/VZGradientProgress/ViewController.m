//
//  ViewController.m
//  VZGradientProgress
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "ViewController.h"
#import "VZGradientProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VZGradientProgressView *progressView = [[VZGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, 300, 5)];
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        progressView.progress = 0.5;
//    });
}

@end
