//
//  ViewController.m
//  AlertOCDemo
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "ViewController.h"
#import "VZAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickAction:(id)sender {
    [self loadAlert];
}

- (void)loadAlert {
    VZAlertView *alertView = [VZAlertView showAlert];
    alertView.title = @"我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题";
    alertView.content = @"我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容";
    alertView.buttonTitle = @"我是按钮";
    alertView.buttonBlock = ^(NSInteger index) {
        if (index == 0) {
            NSLog(@"点击了按钮");
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
