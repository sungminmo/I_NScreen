//
//  NSString+Helper.m
//  STVN
//
//  Created by lambert on 2014. 10. 29..
//
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (NSString *)stringByUrlEncoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8)) ;
}

- (NSString *)stringByUrlDecoding {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)formatDate {
    NSString *formattedOutput;
    
    if ([self length] != 8) {
        formattedOutput = @"";
    }
    else {
        formattedOutput = [NSString stringWithFormat:@"%@-%@-%@",
                           [self substringToIndex:4],
                           [self substringWithRange:NSMakeRange(4, 2)],
                           [self substringFromIndex:6]];
        
    }
    
    return formattedOutput;
}

// Generates alpha-numeric-random string
+ (NSString *)genRandStringLength:(int)len {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

// 입력된 문자열 중 오직 숫자만 반환.
- (NSString *)remainOnlyNumber {
    return [[self componentsSeparatedByCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
}

// strToChar.
unsigned char strToChar (char a, char b) {
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}

// cahr > NSData.
- (NSData *)decodeFromHexidecimal {
    const char *bytes = [self cStringUsingEncoding: NSUTF8StringEncoding];
    NSUInteger length = strlen(bytes);
    unsigned char *r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char *index = r;
    
    while ((*bytes) && (*(bytes +1)))
    {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
    
    NSData *result = [NSData dataWithBytes:r length:length / 2];
    free(r);
    
    return result;
}

// 빈 문자열 여부.
- (BOOL)isEmpty {
    if ((NSNull *)self == [NSNull null]) {
        return YES;
    }
    else if (self == nil) {
        return YES;
    }
    else if ([self length] == 0) {
        return YES;
    }
    else {
        if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

// 트림.
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)encodeBase64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
}

- (NSString *)decodeBase64 {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict {
    NSString *ret = @"";
    if ([dict.allKeys count]) {
        NSMutableArray *mList = [NSMutableArray array];
        for (NSString *key in [dict allKeys]) {
            id obj = dict[key];
            NSString *value = @"";
            if ([obj isKindOfClass:[NSString class]]) {
                value = (NSString *)obj;
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                value = [((NSNumber *)obj) stringValue];
            }
            [mList addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        ret = [mList componentsJoinedByString:@"&"];
    }
    return ret;
}

+ (NSString *)queryParameterEncodingWithParam:(NSString *)param {
    if ([param length] > 0) {
        NSMutableArray *mList = [NSMutableArray array];
        NSArray *list = [param componentsSeparatedByString:@"&"];
        for (NSString *kvCompenent in list) {
            NSArray *kvList = [kvCompenent componentsSeparatedByString:@"="];
            if ([kvList count] < 1) {
                continue;
            }
            NSString *key = kvList[0];
            NSString *val = @"";
            if ([kvList count] == 2) {
                val = [kvList[1] stringByUrlEncoding];
            }
            [mList addObject:[NSString stringWithFormat:@"%@=%@", key, val]];
        }
        if ([mList count] > 0) {
            return [mList componentsJoinedByString:@"&"];
        }
    }
    return @"";
}

// CustomURL 쿼리 파서.
+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {

        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([pair rangeOfString:@"?"].location != NSNotFound ) {
            NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            for (int i = 2; i < [elements count]; i++) {
                val = [val stringByAppendingString:@"="];
                NSString *addValue = [[elements objectAtIndex:i] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                val = [val stringByAppendingString:addValue];
            }
            [dict setObject:val forKey:key];
        }
        else
        {
            NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setObject:val forKey:key];
        }
    }
    return dict;
}

- (BOOL)containsString:(NSString *)aString {
    NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
    return range.location != NSNotFound;
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

+ (BOOL)isContainKorean:(NSString*)word {
    if ([word length] == 0) {
        return NO;
    }
    const char* tmp = [word cStringUsingEncoding:NSUTF8StringEncoding];
    if ([word length] != strlen(tmp)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isDigitOnly:(NSString*)word {
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange nond = [word rangeOfCharacterFromSet:nonDigits];
    if (NSNotFound == nond.location) {
        return YES;
    } else {
        return NO;
    }
}

@end
