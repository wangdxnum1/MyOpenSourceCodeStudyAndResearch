//
//  NSArray+YYAdd.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSArray`.
 */
@interface NSArray (YYAdd)

/**
 Creates and returns an array from a specified property list data.
 从plist 数据转成数组
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSArray *)arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 从plist 字符串转成数组
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSArray *)arrayWithPlistString:(NSString *)plist;

/**
 Serialize the array to a binary property list data.
 数组序列化成plist 数据
 @return A bplist data, or nil if an error occurs.
 */
- (nullable NSData *)plistData;

/**
 Serialize the array to a xml property list string.
 数组序列化成plist 字符串
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)plistString;

/**
 Returns the object located at a random index.
 返回数组中的随机为止的对象
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (nullable id)randomObject;

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 安全的获取数组里的对象，如果index超出count，则返回nil
 @param index The object located at index.
 */
- (nullable id)objectOrNilAtIndex:(NSUInteger)index;

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 把string，number，字典，数组转成json字符串，其它对象则返回nil
 */
- (nullable NSString *)jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)jsonPrettyStringEncoded;

@end


/**
 Provide some some common method for `NSMutableArray`.
 */
@interface NSMutableArray (YYAdd)

/**
 Creates and returns an array from a specified property list data.
 从plist数据生成可变数组
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 从plist字符串生成可变数组
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)arrayWithPlistString:(NSString *)plist;

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 移除数组里的第一个数据
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)removeFirstObject;

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 移除数组里最后一个数据
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
- (void)removeLastObject;

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 移除第一个数据，并返回
 @return The first object, or nil.
 */
- (nullable id)popFirstObject;

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 移除最后数据，并返回
 @return The first object, or nil.
 */
- (nullable id)popLastObject;

/**
 Inserts a given object at the end of the array.
 在最后插入数据
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)appendObject:(id)anObject;

/**
 Inserts a given object at the beginning of the array.
 在最前面插入数据
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)prependObject:(id)anObject;

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 在最后插入数组
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)appendObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 在最前面插入数组
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)prependObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 在某个位置插入数据
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 翻转数组
 */
- (void)reverse;

/**
 Sort the object in this array randomly.
 打乱数组
 */
- (void)shuffle;

@end

NS_ASSUME_NONNULL_END
