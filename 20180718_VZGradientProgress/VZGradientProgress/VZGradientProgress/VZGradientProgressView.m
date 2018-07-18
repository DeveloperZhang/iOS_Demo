//
//  VZGradientProgressView.m
//  VZGradientProgress
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "VZGradientProgressView.h"

@interface VZGradientProgressView ()

@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation VZGradientProgressView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgProgressColor = VZRGBColor(230., 244., 245.);
        [self addSubViewTree];
        self.colorArr = @[(id)VZRGBColor(252, 244, 77).CGColor,(id)VZRGBColor(252, 93, 59).CGColor];
        self.progress = 0.25;
    }
    return self;
}
#pragma mark - private custom method
- (void)addSubViewTree {
    [self bgLayer];
    [self gradientLayer];
}

- (void)updateView {
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
    self.gradientLayer.colors = self.colorArr;
}

#pragma mark - getters and setters
- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        _bgLayer.anchorPoint = CGPointMake(0, 0);
        _bgLayer.backgroundColor = self.bgProgressColor.CGColor;
        _bgLayer.cornerRadius = CGRectGetHeight(self.frame)/2.;
        [self.layer addSublayer:_bgLayer];
    }
    return _bgLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
//        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        self.colorArr = @[(id)VZRGBColor(252, 244, 77).CGColor,(id)VZRGBColor(252, 93, 59).CGColor];
        _gradientLayer.colors = self.colorArr;
        _gradientLayer.cornerRadius = CGRectGetHeight(self.frame)/2.;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

-(void)setColorArr:(NSArray *)colorArr {
    if (colorArr.count >= 2) {
        _colorArr = colorArr;
        [self updateView];
    }else {
        NSLog(@">>>>>颜色数组个数小于2，显示默认颜色");
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateView];
}

@end








