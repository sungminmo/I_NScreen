//
//  UIColor+ColorString.h
//  STVN
//
//  Created by 조백근 on 2014. 7. 31..
//  Copyright (c) 2014년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorString)
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;//16진수 컬러값 문자열로 색상생성
@end
