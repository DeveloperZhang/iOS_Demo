//
//  VZAlertView.m
//  AlertOCDemo
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#define AlertW 280

#define XSpace 10.0

#import "VZAlertView.h"
#import "AppDelegate.h"

@interface VZAlertView()

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation VZAlertView

+ (id)showAlert {
    VZAlertView *alertView = [[VZAlertView alloc] init];
    alertView.frame = [UIScreen mainScreen].bounds;
    alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    UIView *contentView = [[UIView alloc] init];
    alertView.alertView = contentView;
    contentView.layer.cornerRadius = 8.0;
    alertView.alertView.frame = CGRectZero;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = alertView.center;
    alertView.buttonTitle = @"OK";
    [alertView addSubview:contentView];
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    [window addSubview:alertView];
    return alertView;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        if (!_titleLabel) {
            [self getAdaptiveLabel:CGRectMake(2 * XSpace, 2 * XSpace, AlertW - 2 * 2 * XSpace, 50) text:title isTitle:YES];
            [self refreshUI];
        }
    }
}

- (void)setContent:(NSString *)content {
    if (content) {
        _content = content;
        if (!_contentLabel) {
            CGRect frame = CGRectMake(2 * XSpace, 2 * XSpace, AlertW - 2 * 2 * XSpace, 300);
            if (_titleLabel) {
                frame = CGRectMake(2 * XSpace, XSpace + CGRectGetMaxY(self.titleLabel.frame), AlertW - 2 * 2 * XSpace, 300);
            }
            [self getAdaptiveLabel:frame text:content isTitle:NO];
            [self refreshUI];
        }
    }
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    if (buttonTitle) {
        _buttonTitle = buttonTitle;
        if (!_sureButton) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, AlertW, 100);
            button.backgroundColor = [UIColor greenColor];
            [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:button];
            _sureButton = button;
        }
        [_sureButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self refreshUI];
    }
}

- (void)refreshUI {
    CGFloat y1 = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat y2 = CGRectGetMaxY(self.contentLabel.frame);
    CGFloat y = y1 > y2 ? y1 : y2;
    CGFloat y3 = y + XSpace;
    y3 = y3 > 2 * XSpace ? y3 : 2 * XSpace;
    if (self.sureButton) {
        self.sureButton.frame = CGRectMake(2 * XSpace, y3, AlertW - 4 * XSpace, 44);
        y = CGRectGetMaxY(self.sureButton.frame) + 2 * XSpace;
    } else {
        y = y + 2 * XSpace;
    }
    self.alertView.frame = CGRectMake(0, 0, AlertW, y);
    self.alertView.center = self.center;
}

- (void)buttonAction {
    if (self.buttonBlock) {
        self.buttonBlock(0);
    }
    [self removeFromSuperview];
}

- (void)getAdaptiveLabel:(CGRect)rect text:(NSString *)contentString isTitle:(BOOL)isTitle {
    UILabel *contentLabel;
    if (isTitle) {
        if (self.titleLabel) {
            contentLabel = self.titleLabel;
        } else {
            contentLabel = [[UILabel alloc] initWithFrame:rect];
            [self.alertView addSubview:contentLabel];
            self.titleLabel = contentLabel;
        }
    } else {
        if (self.contentLabel) {
            contentLabel = self.contentLabel;
        } else {
            contentLabel = [[UILabel alloc] initWithFrame:rect];
            [self.alertView addSubview:contentLabel];
            self.contentLabel = contentLabel;
        }
    }
    contentLabel.numberOfLines = 0;
    contentLabel.text = contentString;
    if (isTitle) {
        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
    } else {
        contentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    mParaStyle.alignment = NSTextAlignmentCenter;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0, [contentString length])];
    [contentLabel setAttributedText:mAttrStr];
    if (CGRectGetHeight(rect) > 200) {
        [contentLabel sizeToFit];
        contentLabel.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), contentLabel.frame.size.height);
    }
}

@end








