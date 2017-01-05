//
//  ViewController.m
//  TestVFLDemo
//
//  Created by ZhangYu on 17/1/5.
//  Copyright © 2017年 DeveloperZhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testDemo3];
    [self testDemo4];
}

- (void)testDemo4 {
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:yellowView];
    
    NSArray *hVfl = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[yellowView(==_scrollView)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(yellowView,_scrollView)];
    NSArray *vVfl = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[yellowView(700)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(yellowView)];
    [self.scrollView addConstraints:hVfl];
    [self.scrollView addConstraints:vVfl];
}

- (void)testDemo3 {
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:@"点击一下" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints=NO;
    [button setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button];
    NSArray *hVfl = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    NSArray *vVfl = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[button(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    [self.view addConstraints:hVfl];
    [self.view addConstraints:vVfl];
    
    UIButton *button1=[[UIButton alloc]init];
    button1.translatesAutoresizingMaskIntoConstraints=NO;
    [button1 setTitle:@"请不要点击我" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button1];
    
    NSArray *hVfl1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button1]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button1)];
    NSArray *vVfl1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-[button1(==button)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button1,button)];
    [self.view addConstraints:vVfl1];
    [self.view addConstraints:hVfl1];
}

- (void)testDemo {
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    NSString *hVfl = @"H:|-20-[redView(50)]";
    NSString *vVfl = @"V:|-20-[redView(100)]";
    NSDictionary *views = NSDictionaryOfVariableBindings(redView);
    NSLayoutFormatOptions ops = NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllTop;//左边与顶部
    NSArray *hCst = [NSLayoutConstraint constraintsWithVisualFormat:hVfl options:ops metrics:nil views:views];
    NSArray *vCst = [NSLayoutConstraint constraintsWithVisualFormat:vVfl options:ops metrics:nil views:views];
    [self.view addConstraints:hCst];
    [self.view addConstraints:vCst];
}

- (void)testDemo2 {
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    UIView *yellowView = [[UIView alloc]init];
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:yellowView];
    
    NSString *hVfl = @"H:|-20-[redView(50)]-20-[blueView(==redView)]-20-[yellowView(==redView)]";
    NSDictionary *views = NSDictionaryOfVariableBindings(redView,blueView,yellowView);
    NSLayoutFormatOptions ops = NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom;
    NSArray *hCst = [NSLayoutConstraint constraintsWithVisualFormat:hVfl options:ops metrics:nil views:views];
    NSString *vVfl = @"V:[redView(50)]-20-|";
    NSArray *vCst = [NSLayoutConstraint constraintsWithVisualFormat:vVfl options:ops metrics:nil views:views];
    [self.view addConstraints:hCst];
    [self.view addConstraints:vCst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
