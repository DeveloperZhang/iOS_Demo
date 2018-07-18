//
//  VZHttpTool.m
//  VZHttpTool
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "VZHttpTool.h"

#define VZHTTPTOOLBOUNDARY @"__vzhttptoolboundary__"


static VZHttpTool *vzHttpTool;

@interface VZHttpTool ()<NSURLSessionDelegate, NSURLSessionDataDelegate>


@end

@implementation VZHttpTool

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vzHttpTool = [[VZHttpTool alloc] init];
    });
    return vzHttpTool;
}

+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               httpHeader:(NSDictionary *)headerDic
                 httpBody:(NSDictionary *)bodyDic
                 bodyType:(VZHttpBodyType)bodyType
             successBlock:(void (^)(id))successBlock
              failedBlock:(void (^)(NSError *))failedBlock {
    [self requestWithMethod:method url:url httpHeader:headerDic httpBody:bodyDic bodyType:bodyType fromFile:nil successBlock:successBlock failedBlock:failedBlock];
}

+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               httpHeader:(NSDictionary *)headerDic
                 httpBody:(NSDictionary *)bodyDic
                 bodyType:(VZHttpBodyType)bodyType
                 fromFile:(id)formFile
             successBlock:(void (^)(id))successBlock
              failedBlock:(void (^)(NSError *))failedBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (method) {
        request.HTTPMethod = method;
    }
    if (bodyType == VZHttpBodyTypeTextPlain) {
        if (bodyDic) {
            NSArray *arr = bodyDic.allKeys;
            NSMutableArray *bodyArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                NSString *key = arr[i];
                NSString *value = bodyDic[key];
                [bodyArr addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
            NSString *bodyStr = [bodyArr componentsJoinedByString:@"&"];
            request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        }
    } else if (bodyType == VZHttpBodyTypeJson) {
        if (bodyDic) {
            NSError *err;
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:&err];
            if (err) {
                if (failedBlock) {
                    failedBlock(err);
                }
            }
        }
        NSMutableDictionary *hDic = [NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type":@"application/json"}];
        if (headerDic) {
            [hDic addEntriesFromDictionary:headerDic];
        }
        request.allHTTPHeaderFields = hDic;
    }
    
    if (formFile) {
        NSArray *formDataArr = formFile;
        if (formDataArr.count) {
            NSMutableDictionary *hDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
            hDic[@"Content-Type"] = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",VZHTTPTOOLBOUNDARY];
            request.allHTTPHeaderFields = hDic;
        }
        NSMutableData *mutiData = [NSMutableData data];
        NSMutableString *bodyStr = [NSMutableString stringWithFormat:@""];
        
        NSArray *bodyKeyArr = [bodyDic allKeys];
        for (int i = 0; i < bodyKeyArr.count; i++) {
            NSString *key = bodyKeyArr[i];
            NSString *value = bodyDic[key];
            [bodyStr appendFormat:@"--%@\r\n"
             "Content-Disposition: form-data; name=\"%@\"\r\n"
             "\r\n"
             "%@\r\n",
             VZHTTPTOOLBOUNDARY,key,value];
        }
        
        NSData *normalData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        [mutiData appendData:normalData];
        
        for (int i = 0; i < formDataArr.count; i++) {
            NSMutableString *headerStr = [NSMutableString string];
            NSDictionary *dic = formDataArr[i];
            NSData *data = dic[@"data"];
            NSURL *url = dic[@"url"];
            NSString *name = dic[@"name"];
            NSString *key = dic[@"key"];
            NSString *type = dic[@"type"];
            
            NSString *file = nil;
            if (data) {
                file = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            }
            if (url) {
                file = url.absoluteString;
            }
            
            [headerStr appendFormat:
             @"--%@\r\n"
             "Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n"
             "Content-Type: %@\r\n"
             "\r\n",VZHTTPTOOLBOUNDARY,key,name,type];
            
            [mutiData appendData:[headerStr dataUsingEncoding:NSUTF8StringEncoding]];
            [mutiData appendData:data];
            [mutiData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if (bodyDic.count || formDataArr.count) {
            NSString *endStr = [NSString stringWithFormat:@"--%@--",VZHTTPTOOLBOUNDARY];
            [mutiData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        request.HTTPBody = mutiData;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[self shareInstance] delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err2;
        if (error) {
            if (failedBlock) {
                failedBlock(error);
            }
        } else {
            id responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
            if (err2) {
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (successBlock) {
                    successBlock(dataStr?dataStr:data);
                }
            } else {
                if (successBlock) {
                    successBlock(responseObj);
                }
            }
        }
    }];
    //执行任务
    [dataTask resume];
}

+ (void)get:(NSString *)url
successBlock:(void(^)(id))successBlock
failedBlock:(void(^)(NSError*))failedBlock {
    [self get:url urlParamDic:nil successBlock:successBlock failedBlock:failedBlock];
}

+ (void)get:(NSString *)url
urlParamDic:(NSDictionary *)urlParamDic
successBlock:(void(^)(id))successBlock
failedBlock:(void(^)(NSError*))failedBlock {
    if (urlParamDic) {
        NSArray *arr = urlParamDic.allKeys;
        NSMutableArray *bodyArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            NSString *key = arr[i];
            NSString *value = urlParamDic[key];
            [bodyArr addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        NSString *bodyStr = [bodyArr componentsJoinedByString:@"&"];
        url = [url stringByAppendingFormat:@"%@%@", [url containsString:@"?"]?@"&":@"?", bodyStr];
    }
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self requestWithMethod:@"GET" url:url httpHeader:nil httpBody:nil bodyType:[VZHttpTool shareInstance].bodyType successBlock:successBlock failedBlock:failedBlock];
}


+ (void)post:(NSString *)url
    httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id httpResponse))successBlock
 failedBlock:(void(^)(NSError *httpError))failedBlock {
    [self requestWithMethod:@"POST" url:url httpHeader:nil httpBody:bodyDic bodyType:[VZHttpTool shareInstance].bodyType successBlock:^(id httpResponse) {
        if (successBlock) {
            successBlock(httpResponse);
        }
    } failedBlock:^(NSError *httpError) {
        if (failedBlock) {
            failedBlock(httpError);
        }
    }];
}

+ (void)post:(NSString *)url
 addFormData:(void(^)(VZPOSTFormData *))formDataBlock
    httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id))successBlock
 failedBlock:(void(^)(NSError *))failedBlock {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    VZPOSTFormData *data = [VZPOSTFormData new];
    if (formDataBlock) {
        formDataBlock(data);
    }
    NSArray *formDataArr = data.formDataArray;
    [self requestWithMethod:@"POST" url:url httpHeader:headerDic httpBody:bodyDic bodyType:[VZHttpTool shareInstance].bodyType fromFile:formDataArr successBlock:^(id httpResponse) {
        if (successBlock) {
            successBlock(httpResponse);
        }
    } failedBlock:^(NSError *httpError) {
        if (failedBlock) {
            failedBlock(httpError);
        }
    }];
}

@end

@interface VZPOSTFormData () {
    NSMutableArray *_dataArr;
}

@end

@implementation VZPOSTFormData

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataArr = [NSMutableArray array];
        _formDataArray = [NSArray arrayWithArray:_dataArr];
    }
    return self;
}

- (void)addData:(NSData *)data key:(NSString *)key type:(VZHttpFormDataType)type {
    NSString *typeName = nil;
    NSString *fileName = nil;
    switch (type) {
        case VZHttpFormDataTypeJPG:
            typeName = @"image/jpeg";
            fileName = @"fileName.jpg";
            break;
        case VZHttpFormDataTypePNG:
            typeName = @"image/png";
            fileName = @"fileName.png";
            break;
        default:
            return;
            break;
    }
    [self addData:data key:key fileName:fileName type:typeName];
}

- (void)addData:(NSData *)data key:(NSString *)key fileName:(NSString *)fileName type:(NSString *)type {
    //数据为空
    if (!data.length) {
        NSLog(@"vzhttptool:formdata数据为空");
        return;
    }
    //键格式有问题
    if (!key || ![key isKindOfClass:[NSString class]] || [key isEqualToString:@""]) {
        NSLog(@"vzhttptool:键格式有问题");
        return;
    }
    //文件名格式有问题
    if (!fileName || ![fileName isKindOfClass:[NSString class]] || [fileName isEqualToString:@""]) {
        NSLog(@"vzhttptool:文件名格式有问题");
        return;
    }
    //文件类型格式有问题
    if (!type || ![type isKindOfClass:[NSString class]] || [type isEqualToString:@""]) {
        NSLog(@"vzhttptool:文件类型格式有问题");
        return;
    }
    //添加数据
    [_dataArr addObject:@{
                          @"data":data,
                          @"name":fileName,
                          @"type":type,
                          @"key":key
                          }];
    _formDataArray = [NSArray arrayWithArray:_dataArr];
}

@end










