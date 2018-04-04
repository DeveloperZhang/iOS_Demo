//
//  MyView.m
//  20180404_DataSourceDelegateDemo
//
//  Created by Vicent on 2018/4/4.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "MyView.h"

@interface MyView()

@property (nonatomic, strong) NSMutableArray *subViewsArray;

@end

@implementation MyView

- (void)setDataSource:(id<MyViewDataSource>)dataSource {
    if (dataSource) {
        _dataSource = dataSource;
        [self loadSubViews];
    }
}

- (void)loadSubViews {
    NSInteger number = [self.dataSource numberOfSubViews];
    for (int i = 0; i < number; i++) {
        UIView *view = [self.dataSource viewAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        view.tag = 100 + i;
        if (i%2 == 0) {
            view.backgroundColor = [UIColor greenColor];
        } else {
            view.backgroundColor = [UIColor lightGrayColor];
        }
        int lastIndex = (i - 1)>=0?:0;
        UIView *lastView = [self viewWithTag:100 + lastIndex];
        CGFloat orginY = 0;
        if (lastIndex) {
            orginY = CGRectGetMaxY(lastView.frame);
        }
        [self loadConstains:view index:i];
        //创建手势 使用initWithTarget:action:的方法创建
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        //别忘了添加到testView上
        [view addGestureRecognizer:tap];
    }
}

- (void)tapView:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    NSInteger index = view.tag - 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
        [self.delegate didSelectedAtIndex:index];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldSelectedAtIndex:)]) {
        [self.delegate shouldSelectedAtIndex:index];
    }
}

- (CGFloat)orignYAtIndex:(NSInteger)index {
    CGFloat orginY = 0;
    for (int i = 0; i < index; i++) {
        orginY += [self.dataSource heightAtIndex:i];
    }
    return orginY;
}

- (void)loadConstains:(UIView *)view index:(NSInteger)index {
    NSString *hVFL = @"H:|-0-[view]-0-|";
    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"view":view}];
    [self addConstraints:hCons];
    NSString *vVFL = [NSString stringWithFormat:@"V:|-%f-[view(%f)]",[self orignYAtIndex:index],[self.dataSource heightAtIndex:index]];
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"view":view}];
    [self addConstraints:vCons];
}

- (NSMutableArray *)subViewsArray {
    if (_subViewsArray) {
        _subViewsArray = [NSMutableArray mutableCopy];
    }
    return _subViewsArray;
}

@end
