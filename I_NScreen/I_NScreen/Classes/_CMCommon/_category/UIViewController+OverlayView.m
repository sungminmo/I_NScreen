//
//  UIViewController+OverlayView.m
//  STVN
//
//  Created by lambert on 2014. 10. 23..
//
//

#import "UIViewController+OverlayView.h"

@implementation UIViewController (OverlayView)

- (void)showLayer {
    UIView *layer = [[UIView alloc] initWithFrame:self.view.bounds];
    // layer.alpha = 0.5;
    layer.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
}

- (void)hideLayer {
    NSArray *subViews = [self.view subviews];
    UIView *layer = [subViews lastObject];
    [layer removeFromSuperview];
}

@end
