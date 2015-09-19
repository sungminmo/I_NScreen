//
//  UIImage+Color.m
//  STVN
//
//  Created by 조백근 on 2015. 6. 17..
//
//

#import "UIImage+Color.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (Color)

+ (UIImage *)image1x1WithColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    return [UIImage imageWithColor:color withAlpha:alpha withSize:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color withAlpha:(CGFloat)alpha withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0 );
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
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0 );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextSetAlpha(context, 0);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)ImageMerge:(UIImage* ) firstImage image:(UIImage*) secondImage {
    UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, 0 );
    [firstImage drawAtPoint:CGPointMake(0,0)];
    [secondImage drawAtPoint:CGPointMake(0,0)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage* )setOuterLine:(UIImage*)image direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color {
    
    UIImage *newImage = nil;
    UIColor* lineColor = color;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0 );
    [image drawAtPoint:CGPointZero];

    float scale = [UIScreen mainScreen].scale;
    CGRect viewFrame = CGRectMake(0, 0, image.size.width - 0.2*scale, image.size.height - 0.2*scale);

    [lineColor setFill];
    if (direction & HMOuterLineDirectionTop ) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, viewFrame.size.width, weight)];
        [path fill];
    }
    if (direction & HMOuterLineDirectionBottom) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, viewFrame.size.height - weight, viewFrame.size.width, weight)];
        [path fill];
    }
    if (direction & HMOuterLineDirectionLeft) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, weight, viewFrame.size.height)];
        [path fill];
    }
    if (direction & HMOuterLineDirectionRight) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(viewFrame.size.width - weight, 0, weight, viewFrame.size.height)];
        [path fill];
    }

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
    
//    newImage = [newImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.4, 0.4, 0.5, 0.5)];
//    return newImage;
}

-(UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius {
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0 );
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+ (UIImage*)imageWithLabel:(UILabel*)label image:(UIImage*)image isOriginZero:(BOOL)yn {
    CGRect lbFrame = label.frame;
    if (yn) {
        lbFrame.origin.x = 0;
        lbFrame.origin.y = 0;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0 );
    [image drawAtPoint:CGPointMake(0,0)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = lbFrame; // 라벨 위치(이미지의 좌표 기준)
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);// 라벨 배경색
    CGContextFillRect(context, drawRect);
    [label drawTextInRect:drawRect];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage*)imageWithLabel:(UILabel*)label image:(UIImage*)image newSize:(CGSize)imgSize imagePoint:(CGPoint)imgPoint isBold:(BOOL)isBold {
    float scale = [[UIScreen mainScreen] scale];
    
    CGRect lbFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    
    if (scale > 1) {
        CGFloat value = label.font.pointSize * scale;
        if (isBold) {
            label.font = [UIFont boldSystemFontOfSize:value];
        } else {
            label.font = [UIFont systemFontOfSize:value];
        }
        lbFrame = CGRectMake(lbFrame.origin.x * scale, lbFrame.origin.y * scale, lbFrame.size.width * scale, lbFrame.size.height * scale);
        imgSize = CGSizeMake(imgSize.width * scale, imgSize.height * scale);
        imgPoint = CGPointMake(imgPoint.x * scale, imgPoint.y * scale);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, scale );
    [image drawAtPoint:imgPoint];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = lbFrame; // 라벨 위치(이미지의 좌표 기준)
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);// 라벨 배경색
    CGContextFillRect(context, drawRect);
    [label drawTextInRect:drawRect];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (scale > 1) {
        CGFloat value = label.font.pointSize/scale;
        if (isBold) {
            label.font = [UIFont boldSystemFontOfSize:value];
        }
        else {
            label.font = [UIFont systemFontOfSize:value];
        }
    }
    
    return resultImage;
}

+ (UIImage*)imageForButton:(CGSize)sizeForButton bgImage:(UIImage*)bgImage symbol:(UIImage*)symbol symbolRect:(CGRect)symRect text:(NSString*)text point:(CGPoint)textPoint textHeight:(float)textHeight fontValue:(CGFloat)fontValue textColor:(UIColor*)textColor bold:(BOOL)bold {

    float scale = [[UIScreen mainScreen] scale];
    
    //1. UILabel 을 생성하고 텍스트를 세팅한다.
    if (text.length == 0) {
        text = @"";
    }
    NSString* lbText = [text copy];
    UIFont* lbFont = nil;
    fontValue = fontValue*scale;
    if (bold) {
        lbFont = [UIFont boldSystemFontOfSize:fontValue];
    }
    else {
        lbFont = [UIFont systemFontOfSize:fontValue];
    }
    
    CGSize lbSize = [text sizeWithFont:lbFont];
    CGRect lbFrame = CGRectMake(textPoint.x*scale, textPoint.y*scale, lbSize.width, textHeight*scale);
    
    UILabel* lb = nil;
    lb = [[UILabel alloc] initWithFrame:lbFrame];
    lb.backgroundColor = [UIColor blueColor];
    lb.text = lbText;
    lb.font = lbFont;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = textColor;

    //2. 이미지와 레이블을 쌓아서 새로운 이미지를 만든다.
    sizeForButton = CGSizeMake(sizeForButton.width*scale, sizeForButton.height*scale);
    
    //3. 심볼이 없고 텍스트 좌표가 0이면 전체 센터로 세팅한다. 
    if (textPoint.x == 0 && symbol == nil) {
        float posX = (sizeForButton.width - lbSize.width)/2;
        lbFrame = lb.frame;
        lbFrame.origin.x = posX;
        lb.frame = lbFrame;
    }
    
    UIGraphicsBeginImageContextWithOptions(sizeForButton, NO, scale);
    
    if (bgImage != nil) {
        [bgImage drawInRect:CGRectMake(0, 0, sizeForButton.width, sizeForButton.height)];
    }
    
    if (symbol != nil) {
        symRect = CGRectMake(symRect.origin.x*scale, symRect.origin.y*scale, symRect.size.width*scale, symRect.size.height*scale);
        [symbol drawInRect:symRect];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = lbFrame; // 라벨 위치(이미지의 좌표 기준)
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);// 라벨 배경색
    CGContextFillRect(context, drawRect);
    [lb drawTextInRect:drawRect];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //리사이즈블 할 경우 한글이 미묘하게 깨짐
//    resultImage = [resultImage resizableImageWithCapInsets:UIEdgeInsetsMake(resultImage.size.height/2 - 1*scale, resultImage.size.width/2 - 1*scale, resultImage.size.height/2, resultImage.size.width/2) resizingMode:UIImageResizingModeStretch];
    
    return resultImage;
}



@end
