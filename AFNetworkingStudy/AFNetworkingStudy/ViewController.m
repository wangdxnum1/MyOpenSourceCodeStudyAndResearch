//
//  ViewController.m
//  AFNetworkingStudy
//
//  Created by HaKim on 17/4/1.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *httpClient;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.urlString = @"http://www.baidu.com";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testClicked:(UIButton *)sender {
    [self.httpClient GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"html = %@",html);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (AFHTTPSessionManager*)httpClient{
    if(_httpClient == nil){
        _httpClient = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:self.urlString]];
        _httpClient.requestSerializer.timeoutInterval = 30;
        _httpClient.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        _httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //http://blog.csdn.net/wangyanchang21/article/details/51180016 配置https
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO 如果是需要验证自建证书，需要设置为YES
        _httpClient.securityPolicy.allowInvalidCertificates = YES;
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO  主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        _httpClient.securityPolicy.validatesDomainName = NO;
        //取出reponseSerilizer可接受的内容类型集合
        NSMutableSet *set = [NSMutableSet setWithSet:_httpClient.responseSerializer.acceptableContentTypes];
        //增加类型
        [set addObject:@"text/plain"];
        [set addObject:@"text/html"];
        [set addObject:@"application/json"];
        
        //设回去
        _httpClient.responseSerializer.acceptableContentTypes = [set copy];
    }
    return _httpClient;
}

@end
