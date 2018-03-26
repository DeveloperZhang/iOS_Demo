//
//  ViewController.m
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Caculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int result = [NSObject makeCaculators:^(CaculatorMaker *make) {
        make.add(1).add(2).add(3);
    }];
    NSLog(@"result is:%d",result);
    
    CaculatorMaker *c = [[CaculatorMaker alloc] init];
    BOOL isEqual = [[[c caculator:^int(int result) {
        result += 2;
        result *= 5;
        return result;
    }] equal:^BOOL(int result) {
        return result == 10;
    }] isEqual];
    NSLog(@"%d",isEqual);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
