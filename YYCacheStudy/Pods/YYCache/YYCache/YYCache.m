//
//  YYCache.m
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/2/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYCache.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"

@implementation YYCache

// 不可用的初始化方法，编译器会报错
- (instancetype) init {
    NSLog(@"Use \"initWithName\" or \"initWithPath\" to create YYCache instance.");
    return [self initWithPath:@""];
}

// 
- (instancetype)initWithName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:name];
    // .../cache/name 路径
    return [self initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    // 创建内存缓存和硬盘缓存
    if (path.length == 0) return nil;
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:path];
    if (!diskCache) return nil;
    NSString *name = [path lastPathComponent];
    YYMemoryCache *memoryCache = [YYMemoryCache new];
    memoryCache.name = name;
    
    self = [super init];
    _name = name;
    _diskCache = diskCache;
    _memoryCache = memoryCache;
    return self;
}

// 几个创建cacche对象的遍历的静态方法
+ (instancetype)cacheWithName:(NSString *)name {
	return [[YYCache alloc] initWithName:name];
}

+ (instancetype)cacheWithPath:(NSString *)path {
    return [[YYCache alloc] initWithPath:path];
}


#pragma mark - 操作方法

// 是否缓存了某个key的内容，先查找内存的缓存，再查找硬盘缓存的，同步调用，如果硬盘缓存多，可能会阻塞调用线程
- (BOOL)containsObjectForKey:(NSString *)key {
    return [_memoryCache containsObjectForKey:key] || [_diskCache containsObjectForKey:key];
}
// 是否缓存了某个key的内容，先查找内存的缓存，再查找硬盘缓存的，异步调用，结果由回调block参数传入
- (void)containsObjectForKey:(NSString *)key withBlock:(void (^)(NSString *key, BOOL contains))block {
    if (!block) return;
    
    if ([_memoryCache containsObjectForKey:key]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 回调不是在主线程
            block(key, YES);
        });
    } else  {
        [_diskCache containsObjectForKey:key withBlock:block];
    }
}

// 根据key查找缓存对象，同步调用
- (id<NSCoding>)objectForKey:(NSString *)key {
    // 县查找内存
    id<NSCoding> object = [_memoryCache objectForKey:key];
    if (!object) {
        // 没有再查找硬盘缓存
        object = [_diskCache objectForKey:key];
        if (object) {
            // 有的话，内存也缓存一份
            [_memoryCache setObject:object forKey:key];
        }
    }
    return object;
}

// 根据key查找缓存对象，异步调用
- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block {
    if (!block) return;
    id<NSCoding> object = [_memoryCache objectForKey:key];
    if (object) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            block(key, object);
        });
    } else {
        [_diskCache objectForKey:key withBlock:block];
    }
}

// 保存缓存的对象，内存缓存，硬盘缓存，同步调用
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    [_memoryCache setObject:object forKey:key];
    [_diskCache setObject:object forKey:key];
}

// 保存缓存的对象，内存缓存，硬盘缓存，异步调用，缓存好了，调用block
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void (^)(void))block {
    [_memoryCache setObject:object forKey:key];
    [_diskCache setObject:object forKey:key withBlock:block];
}

// 根据key移除缓存的对象，同步
- (void)removeObjectForKey:(NSString *)key {
    [_memoryCache removeObjectForKey:key];
    [_diskCache removeObjectForKey:key];
}

// 根据key移除缓存的对象，异步
- (void)removeObjectForKey:(NSString *)key withBlock:(void (^)(NSString *key))block {
    [_memoryCache removeObjectForKey:key];
    [_diskCache removeObjectForKey:key withBlock:block];
}

// 删除所有的缓存对象，同步
- (void)removeAllObjects {
    [_memoryCache removeAllObjects];
    [_diskCache removeAllObjects];
}

// 删除所有的缓存对象，异步
- (void)removeAllObjectsWithBlock:(void(^)(void))block {
    [_memoryCache removeAllObjects];
    [_diskCache removeAllObjectsWithBlock:block];
}

// 删除所有的缓存对象，有进度，异步
- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end {
    [_memoryCache removeAllObjects];
    [_diskCache removeAllObjectsWithProgressBlock:progress endBlock:end];
    
}

// 描述自身
- (NSString *)description {
    if (_name) return [NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _name];
    else return [NSString stringWithFormat:@"<%@: %p>", self.class, self];
}

@end
