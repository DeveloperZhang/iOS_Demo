//
//  CaculatorMaker.m
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

- (CaculatorMaker *(^)(int))add {
    return ^CaculatorMaker *(int value) {
        self.result += value;
        return self;
    };
}

- (CaculatorMaker *)caculator:(int (^)(int))caculator {
    self.result = caculator(self.result);
    return self;
}

-(CaculatorMaker *)equal:(BOOL (^)(int))operation {
    self.isEqual = operation(self.result);
    return self;
}

@end
