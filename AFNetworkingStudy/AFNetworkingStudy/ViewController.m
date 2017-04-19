//
//  ViewController.m
//  AFNetworkingStudy
//
//  Created by HaKim on 17/4/1.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *httpClient;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) NSMutableData *dataM;

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
    [self.httpClient GET:@"" parameters:@{@"name":@"wang="} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"html = %@",html);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}
- (IBAction)testBtnClicked:(UIButton *)sender {
    NSLog(@"%@", [NSThread currentThread]);
    NSString *test = [[NSString alloc] initWithData:[@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    NSLog(@"test = %@",test);
    //确定请求路径
//    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析服务器返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          //默认在子线程中解析数据
                                          NSLog(@"%@", [NSThread currentThread]);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
}
- (IBAction)test2BtnClicked:(UIButton *)sender {
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象，设置代理
    /**
     第一个参数：配置信息
     第二个参数：设置代理
     第三个参数：队列，如果该参数传递nil 那么默认在子线程中执行
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self delegateQueue:nil];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM];
    //发送请求
    [dataTask resume];
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

-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    //子线程中执行
    NSLog(@"接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);
    self.dataM = [NSMutableData data];
    //默认情况下不接收数据
    //必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"接受到服务器返回数据的时候调用,可能被调用多次 %@",[NSThread currentThread]);
    //拼接服务器返回的数据
    [self.dataM appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"请求完成或者是失败的时候调用,%@",[NSThread currentThread]);
    //解析服务器返回数据
    NSLog(@"%@", [[NSString alloc] initWithData:self.dataM encoding:NSUTF8StringEncoding]);
}

@end
