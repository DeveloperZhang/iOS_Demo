//
//  VZAlertView.h
//  AlertOCDemo
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonActionBlock)(NSInteger index);

@interface VZAlertView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, copy) ButtonActionBlock buttonBlock;



+ (id)showAlert;

@end
