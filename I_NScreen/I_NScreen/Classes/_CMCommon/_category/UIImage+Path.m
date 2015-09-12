//
//  UIImage+Path.m
//  STVN
//
//  Created by lambert on 2014. 11. 5..
//
//

#import "UIImage+Path.h"

@implementation UIImage (Path)

+ (UIImage *)setImageWithPath:(NSString *)path {
    if (!path) { return nil; }
    return [UIImage imageWithContentsOfFile:path];
}

@end
