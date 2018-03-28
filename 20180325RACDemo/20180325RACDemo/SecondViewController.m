//
//  SecondViewController.m
//  20180325RACDemo
//
//  Created by Vicent on 2018/3/27.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface SecondViewController ()

@property (nonatomic, strong) NSString *racString;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)racMacroDemo {
    RAC(self,self.racString) = self.myTextField.rac_textSignal;
    [RACObserve(self, self.racString) subscribeNext:^(id x) {
        NSLog(@"racString:%@",x);
    }];
    RACTuple *tuple = RACTuplePack(@"张三",@20);
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
    NSLog(@"name:%@,age:%@",name,age);
}

- (void)dealArray:(id)data data2:(id)data2 {
    NSLog(@"信号数组为%@,%@",data,data2);
}

- (void)racDemo {
    //监听方法调用
    [[self rac_signalForSelector:@selector(clickAction:)] subscribeNext:^(id x) {
        NSLog(@"接收请求");
    }];
    //KVO
    self.racString = @"123";
    [[self rac_valuesForKeyPath:@"racString" observer:self] subscribeNext:^(id x) {
        NSLog(@"racString值变化为:%@",x);
    }];
    //监听事件
    [[self.clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮点击%@",x);
    }];
    //通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postTest" object:nil] subscribeNext:^(id x) {
        NSLog(@"接收通知%@",x);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postTest" object:@"1"];
    //输入内容监听
    [self.myTextField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"输入内容监听%@",x);
    }];
    //信号组
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal1"];
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal2"];
        return nil;
    }];
    [self rac_liftSelector:@selector(dealArray:data2:) withSignalsFromArray:@[signal1,signal2]];
}

- (IBAction)clickAction:(id)sender {
    NSLog(@"%@",self.racString);
}

- (void)sendNextAction {
    if (self.racSubject) {
        [self.racSubject sendNext:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
