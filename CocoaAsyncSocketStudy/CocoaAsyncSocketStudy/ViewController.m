//
//  ViewController.m
//  CocoaAsyncSocketStudy
//
//  Created by HaKim on 16/2/19.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

@interface ViewController ()
{
    GCDAsyncSocket *asyncSocket;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startSocket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startSocket{
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![asyncSocket connectToHost:@"127.0.0.1" onPort:8080 error:&error])
    {
        NSLog(@"Unable to connect to due to invalid configuration: %@", error);
    }
    else
    {
        NSLog(@"Connecting to \"%@\" on port %d...", @"127.0.0.1", 8080);
    }
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost %@",host);
    
    NSString *message = @"Message from the AsyncSocket Client\r\n";
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:messageData withTimeout:-1 tag:0];
    
    [asyncSocket readDataWithTimeout:30 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:didWriteDataWithTag:");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSLog(@"didReadData %@",str);
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    // Since we requested HTTP/1.0, we expect the server to close the connection as soon as it has sent the response.
    
    NSLog(@"socketDidDisconnect:%p withError:%@", sock, err);
}


@end
