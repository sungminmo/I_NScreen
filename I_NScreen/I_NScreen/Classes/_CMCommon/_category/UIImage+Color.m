//
//  UIImage+Color.m
//  STVN
//
//  Created by 조백근 on 2014. 11. 3..
//
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)image1x1WithColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    return [UIImage imageWithColor:color withAlpha:alpha withSize:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color withAlpha:(CGFloat)alpha withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)clearImageSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextSetAlpha(context, 0);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
