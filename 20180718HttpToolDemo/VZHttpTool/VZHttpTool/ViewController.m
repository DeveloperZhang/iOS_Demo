//
//  ViewController.m
//  VZHttpTool
//
//  Created by Vicent on 2018/7/16.
//  Copyright © 2018年 VicentZ. All rights reserved.
//

#import "ViewController.h"
#import "VZHttpTool.h"

typedef enum : NSUInteger {
    RequestTypeGet,
    RequestTypePost,
    RequestTypePostToUpload
} RequestType;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, assign) RequestType requestType;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrayTitle = @[@"get请求测试",@"post请求测试",@"post上传图片"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
}


#pragma tableView--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"MyTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = self.arrayTitle[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.requestType = indexPath.row;
    switch (self.requestType) {
        case RequestTypeGet:
            [VZHttpTool get:@"http://test.imhuasheng.com//app/v2/appVersion/version" urlParamDic:@{@"id":@"1"}
               successBlock:^(id httpResponse) {
                NSLog(@"%@", httpResponse);
            } failedBlock:^(NSError *httpError) {
                NSLog(@"%@",httpError);
            }];
            break;
        case RequestTypePost:
            [VZHttpTool shareInstance].bodyType = VZHttpBodyTypeJson;
            [VZHttpTool post:@"http://test.imhuasheng.com//app/v2/common/launchImage/info" httpBody:@{@"type":@"0"} successBlock:^(id httpResponse) {
                NSLog(@"%@", httpResponse);
            } failedBlock:^(NSError *httpError) {
                NSLog(@"%@",httpError);
            }];
            break;
        case RequestTypePostToUpload:
            [VZHttpTool shareInstance].bodyType = VZHttpBodyTypeJson;
            [VZHttpTool post:@"http://localhost:8080/TomcatTest/UploadServlet"
                 addFormData:^(VZPOSTFormData *formData) {
                     UIImage *image = [UIImage imageNamed:@"imggg.jpg"];
                     NSData *data = UIImageJPEGRepresentation(image, 1.0f);
                     [formData addData:data key:@"file1" type:VZHttpFormDataTypeJPG];
                 }
                    httpBody:@{
                               @"name":@"aaa",
                               @"password":@"bbb"
                               } successBlock:^(id httpResponse) {
                NSLog(@"%@", httpResponse);
            } failedBlock:^(NSError *httpError) {
                NSLog(@"%@",httpError);
            }];
            break;
        default:
            break;
    }
}


@end





