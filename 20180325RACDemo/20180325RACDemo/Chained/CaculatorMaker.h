//
//  CaculatorMaker.h
//  20180325RACDemo
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 DeveloperZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property(nonatomic, assign)int result;
@property(nonatomic, assign)BOOL isEqual;

- (CaculatorMaker *(^)(int))add;
- (CaculatorMaker *)caculator:(int(^)(int result))caculator;
- (CaculatorMaker *)equal:(BOOL(^)(int result))operation;

@end
