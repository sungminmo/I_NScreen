//
//  UIView+ViewController.m
//  STVN
//
//  Created by 조백근 on 2014. 10. 23..
//
//

#import "UIView+ViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

@end
