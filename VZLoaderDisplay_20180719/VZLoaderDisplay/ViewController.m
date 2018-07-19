//
//  ViewController.m
//  VZLoaderDisplay
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "ViewController.h"
#import "VZDownloadIndicator.h"

@interface ViewController ()

@property (assign, nonatomic)CGFloat downloadedBytes;
@property (nonatomic, strong) VZDownloadIndicator *closedIndicator;
@property (nonatomic, strong) VZDownloadIndicator *filledIndicator;
@property (nonatomic, strong) VZDownloadIndicator *mixedIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat height = floor(([UIScreen mainScreen].bounds.size.height - 20 * 2 - 10 * 2)/3);
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - height)/2;
    
    VZDownloadIndicator *closedIndicator = [[VZDownloadIndicator alloc] initWithFrame:CGRectMake(x, 20, height, height) type:VZIndicatorTypeClosed];
    [closedIndicator setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    closedIndicator.radiusPercent = 0.45;
    self.closedIndicator = closedIndicator;
    [self.view addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    [closedIndicator setAnimationDuration:3.0];
    self.downloadedBytes = 0;
    
    
    VZDownloadIndicator *filledIndicator = [[VZDownloadIndicator alloc] initWithFrame:CGRectMake(x, 10 + CGRectGetMaxY(closedIndicator.frame), height, height) type:VZIndicatorTypeFilled];
    [filledIndicator setBackgroundColor:[UIColor whiteColor]];
    [filledIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [filledIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    filledIndicator.radiusPercent = 0.45;
    [self.view addSubview:filledIndicator];
    [filledIndicator loadIndicator];
    _filledIndicator = filledIndicator;
    [filledIndicator setAnimationDuration:3.0];
    
    
    VZDownloadIndicator *mixedIndicator = [[VZDownloadIndicator alloc] initWithFrame:CGRectMake(x, 10 + CGRectGetMaxY(filledIndicator.frame), height, height) type:VZIndicatorTypeMixed];
    [mixedIndicator setBackgroundColor:[UIColor whiteColor]];
    [mixedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [mixedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    mixedIndicator.radiusPercent = 0.45;
    [self.view addSubview:mixedIndicator];
    [mixedIndicator loadIndicator];
    _mixedIndicator = mixedIndicator;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateView:100];
    });
    
}

- (void)updateView:(CGFloat)val {
    self.downloadedBytes += val;
    [_closedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
    [_filledIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
    [_mixedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
