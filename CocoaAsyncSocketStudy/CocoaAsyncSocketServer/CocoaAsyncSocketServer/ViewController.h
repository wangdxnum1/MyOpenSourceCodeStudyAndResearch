//
//  ViewController.h
//  CocoaAsyncSocketServer
//
//  Created by HaKim on 16/2/19.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

@interface ViewController : NSViewController
{
    dispatch_queue_t socketQueue;
    
    GCDAsyncSocket *listenSocket;
    NSMutableArray *connectedSockets;
    
    BOOL isRunning;
    
    IBOutlet id logView;
    IBOutlet id portField;
    IBOutlet id startStopButton;
}
@end

