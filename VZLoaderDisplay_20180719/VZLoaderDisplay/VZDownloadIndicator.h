//
//  VZDownloadIndicator.h
//  VZLoaderDisplay
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    VZIndicatorTypeClosed,
    VZIndicatorTypeFilled,
    VZIndicatorTypeMixed
} VZIndicatorType;

@interface VZDownloadIndicator : UIView
//半径比例
@property (nonatomic, assign) CGFloat radiusPercent;
//填充颜色
@property (nonatomic, strong) UIColor *fillColor;
//画笔颜色
@property (nonatomic, strong) UIColor *strokeColor;
//动画的总时间
@property(nonatomic, assign)CGFloat animationDuration;

- (id)initWithFrame:(CGRect)frame type:(VZIndicatorType)type;
- (void)loadIndicator;
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes;

@end
