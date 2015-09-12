//
//  NSString+Hash.h
//  STVN
//
//  Created by lambert on 2014. 12. 5..
//
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

- (NSString *)MD5;

- (NSString *)SHA1;

- (NSString *)SHA256;

+ (NSData *)parseHexString:(NSString *)string;

@end
