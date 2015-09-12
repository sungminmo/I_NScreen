//
//  NSData+Hash.h
//  STVN
//
//  Created by lambert on 2014. 12. 5..
//
//

#import <Foundation/Foundation.h>

@interface NSData (Hash)

- (NSData *)MD5;

- (NSData *)SHA1;

- (NSData *)SHA256;

#pragma makr - Base64

+ (NSData *)newDataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;

@end
