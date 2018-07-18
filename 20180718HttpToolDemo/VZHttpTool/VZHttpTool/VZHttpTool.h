//
//  VZHttpTool.h
//  VZHttpTool
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求体类型
typedef enum : NSInteger {
    VZHttpBodyTypeTextPlain = 0,
    VZHttpBodyTypeJson
} VZHttpBodyType;

//文件类型
typedef enum : NSUInteger {
    VZHttpFormDataTypePNG,
    VZHttpFormDataTypeJPG
} VZHttpFormDataType;

@interface VZPOSTFormData: NSObject

@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, strong, readonly) NSArray *formDataArray;

- (void)addData:(NSData *)data key:(NSString *)key type:(VZHttpFormDataType)type;

@end

@interface VZHttpTool : NSObject

/**
 请求体类型
 */
@property (nonatomic, assign) VZHttpBodyType bodyType;

+ (instancetype)shareInstance;
+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               httpHeader:(NSDictionary *)headerDic
                 httpBody:(NSDictionary *)bodyDic
                 bodyType:(VZHttpBodyType)bodyType
             successBlock:(void (^)(id))successBlock
              failedBlock:(void (^)(NSError *))failedBlock;

/**
 GET请求
 GET            url地址
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)get:(NSString *)url
successBlock:(void(^)(id))successBlock
failedBlock:(void(^)(NSError*))failedBlock;


/**
 GET请求
 GET            url地址
 urlParamDic    参数
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)get:(NSString *)url
urlParamDic:(NSDictionary *)urlParamDic
successBlock:(void(^)(id))successBlock
failedBlock:(void(^)(NSError*))failedBlock;


/**
 POST请求
 POST           url地址
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)post:(NSString *)url
    httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id httpResponse))successBlock
 failedBlock:(void(^)(NSError * httpError))failedBlock;

/**
 POST请求带文件
 POST           url地址
 formDataBlock  表单数据
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)post:(NSString *)url
 addFormData:(void(^)(VZPOSTFormData * formData))formDataBlock
    httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id httpResponse))successBlock
 failedBlock:(void(^)(NSError * httpError))failedBlock;

@end
