//
//  NSData+YYAdd.h
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
 Provide hash, encrypt, encode and some common method for `NSData`.
 对NSData，二进制数据记性hash计算，加密，编码
 */
@interface NSData (YYAdd)

#pragma mark - Hash
///=============================================================================
/// @name Hash 各种hash计算
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 小写的md2 hash 的字符串
 */
- (NSString *)md2String;

/**
 Returns an NSData for md2 hash.
 md2 数据
 */
- (NSData *)md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 小写的md4 hash 字符串
 */
- (NSString *)md4String;

/**
 Returns an NSData for md4 hash.
 md4 数据
 */
- (NSData *)md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 md5 hash 字符串
 */
- (NSString *)md5String;

/**
 Returns an NSData for md5 hash.
 md5 hash 数据
 */
- (NSData *)md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 sha1 hash 字符串
 */
- (NSString *)sha1String;

/**
 Returns an NSData for sha1 hash.
 sha1 hash 数据
 */
- (NSData *)sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 sha224 hash 字符串
 */
- (NSString *)sha224String;

/**
 Returns an NSData for sha224 hash.
 sha224 数据
 */
- (NSData *)sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 sha256 hash 字符串
 */
- (NSString *)sha256String;

/**
 Returns an NSData for sha256 hash.
 sha256
 */
- (NSData *)sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 sha384字符串
 */
- (NSString *)sha384String;

/**
 Returns an NSData for sha384 hash.
 sha384 数据
 */
- (NSData *)sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 sha512 字符串
 */
- (NSString *)sha512String;

/**
 Returns an NSData for sha512 hash.
 sha512 数据
 */
- (NSData *)sha512Data;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacMD5DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA224DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA256DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA384DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA512DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 crc32 字符串
 */
- (NSString *)crc32String;

/**
 Returns crc32 hash.
 */
- (uint32_t)crc32;


#pragma mark - Encrypt and Decrypt
///=============================================================================
/// @name Encrypt and Decrypt 加密和解密
///=============================================================================

/**
 Returns an encrypted NSData using AES.
 AES加密数据
 
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 
 @param iv    An initialization vector length of 16(128bits).
              Pass nil when you don't want to use iv.
 
 @return      An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSData *)aes256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 Returns an decrypted NSData using AES.
 AES解密
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 
 @param iv    An initialization vector length of 16(128bits).
              Pass nil when you don't want to use iv.
 
 @return      An NSData decrypted, or nil if an error occurs.
 */
- (nullable NSData *)aes256DecryptWithkey:(NSData *)key iv:(nullable NSData *)iv;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode 编码和解码
///=============================================================================

/**
 Returns string decoded in UTF8.
 数据按utf-8编码解析，返回字符串
 */
- (nullable NSString *)utf8String;

/**
 Returns a uppercase NSString in HEX.
 返回16进制的字符串
 */
- (nullable NSString *)hexString;

/**
 Returns an NSData from hex string.
 16进制字符串转成二进制
 @param hexString   The hex string which is case insensitive.
 
 @return a new NSData, or nil if an error occurs.
 */
+ (nullable NSData *)dataWithHexString:(NSString *)hexString;

/**
 Returns an NSString for base64 encoded.
 二进制转成base64 字符串
 */
- (nullable NSString *)base64EncodedString;
/**
 Returns an NSData from base64 encoded string.
 base64 变为 二进制数据
 
 @warning This method has been implemented in iOS7.
 
 @param base64EncodedString  The encoded string.
 */
+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 Returns an NSDictionary or NSArray for decoded self.
 Returns nil if an error occurs.
 json二进制 解析为 数组或者字典
 */
- (nullable id)jsonValueDecoded;


#pragma mark - Inflate and deflate
///=============================================================================
/// @name Inflate and deflate 解压缩
///=============================================================================

/**
 Decompress data from gzip data.
 @return Inflated data.
 */
- (nullable NSData *)gzipInflate;

/**
 Comperss data to gzip in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)gzipDeflate;

/**
 Decompress data from zlib-compressed data.
 @return Inflated data.
 */
- (nullable NSData *)zlibInflate;

/**
 Comperss data to zlib-compressed in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)zlibDeflate;


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Create data from the file in main bundle (similar to [UIImage imageNamed:]).
 从本地加载数据
 @param name The file name (in main bundle).
 
 @return A new data create from the file.
 */
+ (nullable NSData *)dataNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
