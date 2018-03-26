//
//  NSObject+Caculator.h
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaculatorMaker.h"

@interface NSObject (Caculator)

+ (int)makeCaculators:(void(^)(CaculatorMaker *make))caculatorMaker;

@end
