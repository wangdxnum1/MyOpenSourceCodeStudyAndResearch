//
//  UIApplication+YYAdd.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIApplication`.
 UIApplication 的分类
 */
@interface UIApplication (YYAdd)

/// "Documents" folder in this app's sandbox.获取document的路径
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "Caches" folder in this app's sandbox.，获取Caches的路径
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "Library" folder in this app's sandbox.获取library的路径
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"  app 的bundle id
@property (nullable, nonatomic, readonly) NSString *appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *appVersion; // app 版本

/// Application's Build number. e.g. "123"
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;    // app build version

/// Whether this app is priated (not install from appstore).判断app 是否是私有的，不是从app 上下载的
@property (nonatomic, readonly) BOOL isPirated;

/// Whether this app is being debugged (debugger attached). 判断是否在被调试
@property (nonatomic, readonly) BOOL isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs) 当前线程使用的内存
@property (nonatomic, readonly) int64_t memoryUsage;    

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)    cpu 使用率情况
@property (nonatomic, readonly) float cpuUsage;


/**
 Increments the number of active network requests.
 If this number was zero before incrementing, this will start animating the 
 status bar network activity indicator.
 状态栏增加菊花显示
 This method is thread safe.
 */
- (void)incrementNetworkActivityCount;

/**
 Decrements the number of active network requests. 
 If this number becomes zero after decrementing, this will stop animating the 
 status bar network activity indicator.
 状态栏减少菊花显示
 This method is thread safe.
 */
- (void)decrementNetworkActivityCount;


/// Returns YES in App Extension.   是否是app 扩展
+ (BOOL)isAppExtension;

/// Same as sharedApplication, but returns nil in App Extension.
+ (nullable UIApplication *)sharedExtensionApplication;

@end

NS_ASSUME_NONNULL_END
