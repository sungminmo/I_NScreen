//
//  NSDate+Helper.h
//  STVN
//
//  Created by lambert on 2014. 11. 11..
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

+ (NSString*) stringFromDateString:(NSString*)dateString beforeFormat:(NSString*)beforeFormat afterFormat:(NSString*)afterFormat;

//특정시점의 날짜를 추출한다.
+ (NSString*)stringFromSomeDateDays:(NSInteger)somedays now:(NSDate*)nowDate;

+ (BOOL)isSunday;
+ (BOOL)isSaturday;
@end
