//
//  ViewController.m
//  20180404_DataSourceDelegateDemo
//
//  Created by Vicent on 2018/4/4.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()<MyViewDataSource,MyViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyView *myView = [MyView new];
    myView.dataSource = self;
    myView.delegate = self;
    myView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:myView];
    NSString *hVFL = @"H:|-0-[myView]-0-|";
    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"myView":myView}];
    [self.view addConstraints:hCons];

    NSString *vVFL = @"V:|-0-[myView]-0-|";
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"myView":myView}];
    [self.view addConstraints:vCons];
}

- (NSInteger)numberOfSubViews {
    return 3;
}

-(UIView *)viewAtIndex:(NSInteger)index {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)heightAtIndex:(NSInteger)index {
    if (index == 0) {
        return 30;
    }
    return 66.;
}

-(void)didSelectedAtIndex:(NSInteger)index {
    NSLog(@"%s--index is %ld",__func__,(long)index);
}

@end
