//
//  VZGradientProgressView.h
//  VZGradientProgress
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VZRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface VZGradientProgressView : UIView

/**
 *  进度条背景颜色  默认是 （230, 244, 245）
 */
@property (nonatomic, strong) UIColor *bgProgressColor;

/**
 *  进度条渐变颜色数组，颜色个数>=2
 *  默认是 @[(id)VZRGBColor(252, 244, 77).CGColor,(id)VZRGBColor(252, 93, 59).CGColor]
 */
@property (nonatomic, strong) NSArray *colorArr;

/**
 *  进度 默认是0.2
 */
@property (nonatomic, assign) CGFloat progress;

@end
