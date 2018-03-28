//
//  ViewController.m
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Caculator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)racMulticastConnection {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        return nil;
    }];
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者一信号");
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号");
    }];
    [connection connect];
}

- (void)racSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接收请求");
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接收请求");
    }];
}

- (void)racCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    self.command = command;
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [self.command execute:@1];
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [self.command execute:@1];
}

- (void)racDic {
    NSDictionary *dic = @{@"name":@"Tom",@"age":@18};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x){
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@:%@",key,value);
    }];
}

- (void)racArray {
    NSArray *numbers = @[@1,@2,@3];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if([segue.identifier compare:@"mySegue"] == NO) {
        SecondViewController *vc = segue.destinationViewController;
        vc.racSubject = [RACSubject subject];
        [vc.racSubject subscribeNext:^(id x) {
            NSLog(@"点击了按钮事件");
        }];
    }
}

- (void)testRACSubject {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者");
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者");
    }];
    [subject sendNext:@1];
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者接收的数据%@",x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者接收的数据%@",x);
    }];
}

- (void)testSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"接收到数据");
    }];
}

- (void)testChainAction {
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

@end
