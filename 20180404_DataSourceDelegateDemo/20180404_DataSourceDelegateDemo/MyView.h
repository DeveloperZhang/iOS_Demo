//
//  MyView.h
//  20180404_DataSourceDelegateDemo
//
//  Created by Vicent on 2018/4/4.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyViewDataSource

- (NSInteger)numberOfSubViews;
- (UIView *)viewAtIndex:(NSInteger)index;
- (CGFloat)heightAtIndex:(NSInteger)index;

@end

@protocol MyViewDelegate<NSObject>

- (void)didSelectedAtIndex:(NSInteger)index;
@optional
- (void)shouldSelectedAtIndex:(NSInteger)index;

@end


@interface MyView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) id <MyViewDataSource>dataSource;
@property (nonatomic, strong) id <MyViewDelegate>delegate;

@end
