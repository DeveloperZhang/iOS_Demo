//
//  NSObject+Caculator.m
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import "NSObject+Caculator.h"

@implementation NSObject (Caculator)

+(int)makeCaculators:(void (^)(CaculatorMaker *))caculatorMaker {
    CaculatorMaker *maker = [[CaculatorMaker alloc] init];
    caculatorMaker(maker);
    return maker.result;
}

@end
