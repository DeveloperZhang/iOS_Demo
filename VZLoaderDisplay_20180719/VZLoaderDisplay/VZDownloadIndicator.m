//
//  VZDownloadIndicator.m
//  VZLoaderDisplay
//
//  Created by Vicent on 2018/7/18.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "VZDownloadIndicator.h"

@interface VZDownloadIndicator ()

//指示器类型
@property (nonatomic, assign) VZIndicatorType indicatorType;
//指示器图层 -- filled和mixed类型
@property (nonatomic, strong) CAShapeLayer *indicateShapeLayer;
//覆盖图层 -- closed类型
@property (nonatomic, strong) CAShapeLayer *coverLayer;
//动画图层
@property (nonatomic, strong) CAShapeLayer *animatingLayer;
//圆环背景色
@property (nonatomic, strong) UIColor *closedIndicatorBackgroundStrokeColor;
//圆环宽度
@property(nonatomic, assign)CGFloat coverWidth;
//动画路径数组
@property(nonatomic, strong)NSMutableArray *paths;
//上一次更新的路径
@property(nonatomic, strong)UIBezierPath *lastUpdatedPath;
//上一次弧度
@property(nonatomic, assign)CGFloat lastSourceRadian;

@end

@implementation VZDownloadIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorType = VZIndicatorTypeClosed;
        [self initAttributes];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(VZIndicatorType)type {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _indicatorType = type;
        [self initAttributes];
    }
    return self;
}

- (void)initAttributes {
    if (self.indicatorType == VZIndicatorTypeClosed) {
        self.radiusPercent = 0.5;
        _coverLayer = [CAShapeLayer layer];
        _animatingLayer = _coverLayer;
        
        _fillColor = [UIColor clearColor];
        _strokeColor = [UIColor whiteColor];
        _closedIndicatorBackgroundStrokeColor = [UIColor grayColor];
        _coverWidth = 3.0;
    } else {
        if(_indicatorType == VZIndicatorTypeFilled) {
            // only indicateShapeLayer
            _indicateShapeLayer = [CAShapeLayer layer];
            _animatingLayer = _indicateShapeLayer;
            self.radiusPercent = 0.5;
            _coverWidth = 2.0;
        } else {
            // indicateShapeLayer and coverLayer
            _indicateShapeLayer = [CAShapeLayer layer];
            _coverLayer = [CAShapeLayer layer];
            _animatingLayer = _indicateShapeLayer;
            _coverWidth = 2.0;
            self.radiusPercent = 0.4;
        }
        
        // set the fill color
        _fillColor = [UIColor whiteColor];
        _strokeColor = [UIColor whiteColor];
        _closedIndicatorBackgroundStrokeColor = [UIColor clearColor];
    }
    
    _animatingLayer.frame = self.bounds;
    [self.layer addSublayer:_animatingLayer];
    _paths = [NSMutableArray array];
    _animationDuration = 1.0;
}

- (void)drawRect:(CGRect)rect {
    if (self.indicatorType == VZIndicatorTypeClosed) {
        CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) - self.coverWidth;
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        UIBezierPath *coverPath = [UIBezierPath bezierPath];
        [coverPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
        [_closedIndicatorBackgroundStrokeColor set];
        [coverPath setLineWidth:self.coverWidth];
        [coverPath stroke];
    } else if (self.indicatorType == VZIndicatorTypeMixed) {
        CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) - self.coverWidth;
        
        CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        UIBezierPath *coverPath = [UIBezierPath bezierPath]; //empty path
        [coverPath setLineWidth:_coverWidth];
        [coverPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
        [_fillColor set];
        [coverPath setLineWidth:self.coverWidth];
        [coverPath stroke];
    }
}

- (void)loadIndicator {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //初始化的底部圆环
    UIBezierPath *initialPath = [UIBezierPath bezierPath];
    
    if (self.indicatorType == VZIndicatorTypeClosed) {
        [initialPath addArcWithCenter:center radius:(MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES];
    } else {
        if(_indicatorType == VZIndicatorTypeMixed) {
            //手动调用drawRect方法?当前情况可以不写
//            [self setNeedsDisplay];
        }
        CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) * self.radiusPercent;
        [initialPath addArcWithCenter:center radius:radius startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES]; //add the arc
    }
    
    _animatingLayer.path = initialPath.CGPath;
    _animatingLayer.strokeColor = _strokeColor.CGColor;
    _animatingLayer.fillColor = _fillColor.CGColor;
    _animatingLayer.lineWidth = _coverWidth;
    self.lastSourceRadian = degreeToRadian(-90);
}

- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes {
    //最后更新的路径
    _lastUpdatedPath = [UIBezierPath bezierPathWithCGPath:_animatingLayer.path];
    [_paths removeAllObjects];
    
    CGFloat destinationRadian = [self destinationAngleForRatio:(downloadedBytes/bytes)];
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) - self.coverWidth;
    [_paths addObjectsFromArray:[self keyframePathsWithDuration:self.animationDuration lastUpdatedRadian:self.lastSourceRadian newRadian:destinationRadian  radius:radius type:_indicatorType]];
    
    //初始化路径为数组最后一个元素,保持连贯性
    _animatingLayer.path = (__bridge CGPathRef _Nullable)(_paths[_paths.count - 1]);
    self.lastSourceRadian = destinationRadian;
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setValues:_paths];
    [pathAnimation setDuration:self.animationDuration];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [pathAnimation setRemovedOnCompletion:YES];
    [_animatingLayer addAnimation:pathAnimation forKey:@"path"];
}

//计算所有关键帧动画的数组
- (NSArray *)keyframePathsWithDuration:(CGFloat)duration lastUpdatedRadian:(CGFloat)lastUpdatedRadian newRadian:(CGFloat)newRadian radius:(CGFloat)radius type:(VZIndicatorType)type {
    //总帧数
    NSUInteger frameCount = ceil(duration * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:frameCount + 1];
    for (int frame = 0; frame <= frameCount; frame++) {
        CGFloat startRadian = degreeToRadian(-90);
        //计算每一帧对应的截止弧度
        CGFloat endRadian = lastUpdatedRadian + (((newRadian - lastUpdatedRadian) * frame)/frameCount);
        [array addObject:(id)([self pathWithStartRadian:startRadian endRadian:endRadian radius:radius type:type].CGPath)];
    }
    return [NSArray arrayWithArray:array];
}

//创建每一帧的贝塞尔路径
- (UIBezierPath *)pathWithStartRadian:(CGFloat)startRadian endRadian:(CGFloat)endRadian radius:(CGFloat)radius type:(VZIndicatorType)type {
    BOOL clockwise = startRadian < endRadian;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (type == VZIndicatorTypeClosed) {
        [path addArcWithCenter:center radius:radius startAngle:startRadian endAngle:endRadian clockwise:clockwise];
    } else {
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:radius startAngle:startRadian endAngle:endRadian clockwise:clockwise];
        [path closePath];
    }
    return path;
}

//角度转弧度
float degreeToRadian(float degree) {
    return ((degree * M_PI)/180.0f);
}

//距离起点(-90度)的目标弧度
- (CGFloat)destinationAngleForRatio:(CGFloat)ratio
{
    return (degreeToRadian((360*ratio) - 90));
}

#pragma mark Setter Methods
- (void)setFillColor:(UIColor *)fillColor
{
    if(_indicatorType == VZIndicatorTypeClosed)//如果是关闭的圆环则没有填充色
        _fillColor = [UIColor clearColor];
    else
        _fillColor = fillColor;
}

- (void)setRadiusPercent:(CGFloat)radiusPercent
{
    if(_indicatorType == VZIndicatorTypeClosed)//如果是关闭的圆环则没半径百分比只能为一半
    {
        _radiusPercent = 0.5;
        return;
    }
    
    if(radiusPercent > 0.5 || radiusPercent < 0)
        return;
    else
        _radiusPercent = radiusPercent;
    
}

- (void)setIndicatorAnimationDuration:(CGFloat)duration
{
    self.animationDuration = duration;
}

@end
