//
//  NSString+Hash.m
//  STVN
//
//  Created by lambert on 2014. 12. 5..
//
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Hash)

- (NSString *)MD5 {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (NSString *)SHA1 {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (NSString *)SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

+ (NSData *)parseHexString:(NSString *)string {
    char buffer[3] = { 0, 0, 0 };
    NSMutableData* data = [NSMutableData dataWithCapacity:string.length / 2];
    for (NSUInteger i = 0; i < string.length / 2; i++) {
        buffer[0] = [string characterAtIndex:i * 2];
        buffer[1] = [string characterAtIndex:i * 2 + 1];
        const char byte = strtol(buffer, NULL, 16);
        [data appendBytes:&byte length:1];
    }
    return data;
}

- (unsigned int)UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)toHexString:(unsigned char *)data length:(unsigned int)length {
    NSMutableString *hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

@end
