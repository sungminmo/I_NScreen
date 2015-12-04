//
//  NSDate+Helper.m
//  STVN
//
//  Created by lambert on 2014. 11. 11..
//
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSString *displayString = nil;
    
    // comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
    if (midnight_result == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];

        NSComparisonResult lastweek_result = [date compare:lastweek];
        if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [displayFormatter setDateFormat:@"EEEE h:mm a"];
            } else {
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
            }
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d"];
                }
            } else {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
                }
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    return [[self class] stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];

    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dateFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}


+ (NSString*) stringFromDateString:(NSString*)dateString beforeFormat:(NSString*)beforeFormat afterFormat:(NSString*)afterFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    [formatter setLocale:locale];
    formatter.dateFormat = beforeFormat;
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = afterFormat;
    return [[formatter stringFromDate:date]uppercaseString];
}

+ (BOOL)isSunday {
    if ([NSDate todayWeekIndex] == 1) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSaturday {
    if ([NSDate todayWeekIndex] == 7) {
        return YES;
    }
    return NO;
}

+ (NSInteger)todayWeekIndex {
    NSDate *now = [NSDate date];
    NSString *nowFullText = [now stringWithFormat:[NSDate dbFormatString]];
    NSString *today = [NSDate stringFromDateString:nowFullText beforeFormat:[NSDate dbFormatString] afterFormat:@"yyyyMMdd"];
    
    NSInteger y = [[today substringToIndex:4] integerValue];
    NSInteger m = [[today substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger d = [[today substringFromIndex:6] integerValue];
    
    CFAbsoluteTime newTime = 0;
    const unsigned char format[] = "yMd";
    BOOL itWorked = CFCalendarComposeAbsoluteTime (
                                                   CFCalendarCopyCurrent(),
                                                   &newTime,
                                                   format,
                                                   y, m, d
                                                   );
    if (itWorked) {//sun = 1, sat = 7
        NSInteger weekIndex = CFCalendarGetOrdinalityOfUnit (
                                                             CFCalendarCopyCurrent(),
                                                             kCFCalendarUnitDay,
                                                             kCFCalendarUnitWeek,
                                                             newTime
                                                             );
        return weekIndex;

    }
    return -1;
}

+ (NSString*)stringFromSomeDateDays:(NSInteger)somedays now:(NSDate*)nowDate {
    
    NSDate *now = [NSDate date];
    if (nowDate != nil) {
        now = nowDate;
    }
    
    NSString *nowFullText = [now stringWithFormat:[NSDate dbFormatString]];
    NSString *today = [NSDate stringFromDateString:nowFullText beforeFormat:[NSDate dbFormatString] afterFormat:@"yyyyMMdd"];
    
    NSInteger y = [[today substringToIndex:4] integerValue];
    NSInteger m = [[today substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger d = [[today substringFromIndex:6] integerValue];
    
    CFAbsoluteTime newTime = 0;
    const unsigned char format[] = "yMd";
    BOOL isSuccess = CFCalendarComposeAbsoluteTime (
                                                   CFCalendarCopyCurrent(),
                                                   &newTime,
                                                   format,
                                                   y, m, d
                                                   );
    if (!isSuccess) {
        DDLogError(@"newDate creating Fail~!");
        return nil;
    }
    
    NSString *strReturn = nil;
    NSDate *someDate = nil;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:[NSDate timestampFormatString]];
    
    NSTimeInterval weekInterval = 3600*24*somedays;
    someDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(newTime + weekInterval)];
    strReturn = [df stringFromDate:someDate];
    
    return strReturn;
}



@end
