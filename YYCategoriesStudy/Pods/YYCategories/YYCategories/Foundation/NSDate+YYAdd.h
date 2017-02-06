//
//  NSDate+YYAdd.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `NSDate`.
 NSDate 的扩展，日期操作
 */
@interface NSDate (YYAdd)

#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties 日期分割成的属性，例如年，月，日等，还有自己的一些属性没比如1年中第几礼拜
///=============================================================================

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component 纳秒
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting) 星期几
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5) 一个月的第几礼拜
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)  一年的第几礼拜
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component   暂不知什么意思
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component   季度
@property (nonatomic, readonly) BOOL isLeapMonth; ///< Weather the month is leap month  闰月
@property (nonatomic, readonly) BOOL isLeapYear; ///< Weather the year is leap year     闰年
@property (nonatomic, readonly) BOOL isToday; ///< Weather date is today (based on current locale)  判断是否是今天
@property (nonatomic, readonly) BOOL isYesterday; ///< Weather date is yesterday (based on current locale)  是否是昨天

#pragma mark - Date modify
///=============================================================================
/// @name Date modify 日期计算，基本的按年，按月，俺礼拜，按日，按小时，按分钟，按秒等计算
///=============================================================================

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 1个日期，按年来计算，1年之后的今天，1年之前的今天
 
 @param years  Number of years to add.
 @return Date modified by the number of desired years.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 按月来计算，今日2017-01-17  -1 则为 2016-12-17
 @param months  Number of months to add.
 @return Date modified by the number of desired months.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 按礼拜来计算 ，今日2017-01-17  -1 则为 2017-01-10
 @param weeks  Number of weeks to add.
 @return Date modified by the number of desired weeks.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 按日来计算，今日2017-01-17  -1 则为 2017-01-16
 @param days  Number of days to add.
 @return Date modified by the number of desired days.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 按小时来计算
 @param hours  Number of hours to add.
 @return Date modified by the number of desired hours.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 按分来计算
 @param minutes  Number of minutes to add.
 @return Date modified by the number of desired minutes.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 按秒来计算
 @param seconds  Number of seconds to add.
 @return Date modified by the number of desired seconds.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format   日期格式化相关
///=============================================================================

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 格式化日期。例如@"yyyy-MM-dd HH:mm:ss"
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 可以设置时区和地区
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZone  Desired time zone.
 
 @param locale    Desired locale.
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

/**
 Returns a string representing this date in ISO8601 format.
 e.g. "2010-07-09T16:13:30+12:00"
 ISO8601 格式的字符串
 @return NSString representing the formatted date string in ISO8601.
 */
- (nullable NSString *)stringWithISOFormat;

/**
 Returns a date parsed from given string interpreted using the format.
 根据string，formater，返回时间格式
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 @param timeZone   The time zone, can be nil.
 @param locale     The locale, can be nil.
 根据string，formater，返回时间格式，可以设置时区和地区
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

/**
 Returns a date parsed from given string interpreted using the ISO8601 format.
 
 @param dateString The date string in ISO8601 format. e.g. "2010-07-09T16:13:30+12:00"
 ISO8601 format 字符串解析成时间
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithISOFormatString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
