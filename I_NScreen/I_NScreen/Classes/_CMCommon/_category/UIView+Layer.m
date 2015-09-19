//
//  UIView+Layer.m
//  STVN
//
//  Created by 조백근 on 2015. 6. 19..
//
//

#import "UIView+Layer.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Layer)

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners radious:(CGFloat)radious
{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radious, radious)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
    
    UIGraphicsEndImageContext();
}

+ (void)setOuterLine:(UIView*)view direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color {
    return [UIView setOuterLine:view Frame:view.bounds direction:direction lineWeight:weight lineColor:color];
//    UIColor* lineColor = color;
//    CGRect viewFrame = view.bounds;
//
//    UIGraphicsBeginImageContextWithOptions(viewFrame.size, NO, 0);
//    
//    [lineColor setFill];
//    if (direction & HMOuterLineDirectionTop ) {
//        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, viewFrame.size.width, weight)];
//        [path fill];
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer new];
//        shapeLayer.frame = viewFrame;
//        shapeLayer.path = path.CGPath;
//        
//        CALayer *maskLayer = [CALayer new];
//        maskLayer.frame = viewFrame;
//        maskLayer.backgroundColor = lineColor.CGColor;
//        maskLayer.opacity = 1;
//        [view.layer addSublayer:maskLayer];
//        
//        maskLayer.mask = shapeLayer;
//    }
//    if (direction & HMOuterLineDirectionBottom) {
//        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, viewFrame.size.height - weight, viewFrame.size.width, weight)];
//        [path fill];
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer new];
//        shapeLayer.frame = viewFrame;
//        shapeLayer.path = path.CGPath;
//        
//        CALayer *maskLayer = [CALayer new];
//        maskLayer.frame = viewFrame;
//        maskLayer.backgroundColor = lineColor.CGColor;
//        maskLayer.opacity = 1;
//        [view.layer addSublayer:maskLayer];
//        
//        maskLayer.mask = shapeLayer;
//    }
//    if (direction & HMOuterLineDirectionLeft) {
//        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, weight, viewFrame.size.height)];
//        [path fill];
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer new];
//        shapeLayer.frame = viewFrame;
//        shapeLayer.path = path.CGPath;
//        
//        CALayer *maskLayer = [CALayer new];
//        maskLayer.frame = viewFrame;
//        maskLayer.backgroundColor = lineColor.CGColor;
//        maskLayer.opacity = 1;
//        [view.layer addSublayer:maskLayer];
//        
//        maskLayer.mask = shapeLayer;
//    }
//    if (direction & HMOuterLineDirectionRight) {
//        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(viewFrame.size.width - weight, 0, weight, viewFrame.size.height)];
//        [path fill];
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer new];
//        shapeLayer.frame = viewFrame;
//        shapeLayer.path = path.CGPath;
//        
//        CALayer *maskLayer = [CALayer new];
//        maskLayer.frame = viewFrame;
//        maskLayer.backgroundColor = lineColor.CGColor;
//        maskLayer.opacity = 1;
//        [view.layer addSublayer:maskLayer];
//        
//        maskLayer.mask = shapeLayer;
//    }
//    
//    UIGraphicsEndImageContext();
}

+ (void)setTriangleWithColor:(UIColor*)fill view:(UIView*)view {
    CGRect viewFrame = view.bounds;
    UIGraphicsBeginImageContextWithOptions(viewFrame.size, NO, 0);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.fillColor = fill.CGColor;
    shapeLayer.frame = viewFrame;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(viewFrame), CGRectGetMinY(viewFrame))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(viewFrame), CGRectGetMidY(viewFrame))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(viewFrame), CGRectGetMaxY(viewFrame))];
    [path closePath];
    
    shapeLayer.path = path.CGPath;
    [view.layer addSublayer:shapeLayer];
    
    UIGraphicsEndImageContext();
}

+ (void)setOuterLine:(UIView*)view Frame:(CGRect)layerFrame direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color {
    UIColor* lineColor = color;
    CGRect viewFrame = view.bounds;
    
    UIGraphicsBeginImageContextWithOptions(viewFrame.size, NO, 0);
    
    [lineColor setFill];
    if (direction & HMOuterLineDirectionTop ) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, layerFrame.size.width, weight)];
        [path fill];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.frame = layerFrame;
        shapeLayer.path = path.CGPath;
        
        CALayer *maskLayer = [CALayer new];
        maskLayer.shouldRasterize = YES;
        maskLayer.name = @"outerLine";
        maskLayer.frame = viewFrame;
        maskLayer.backgroundColor = lineColor.CGColor;
        maskLayer.opacity = 1;
        [view.layer addSublayer:maskLayer];
        
        maskLayer.mask = shapeLayer;
    }
    if (direction & HMOuterLineDirectionBottom) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, layerFrame.size.height - weight, layerFrame.size.width, weight)];
        [path fill];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.frame = layerFrame;
        shapeLayer.path = path.CGPath;
        
        CALayer *maskLayer = [CALayer new];
        maskLayer.shouldRasterize = YES;
        maskLayer.name = @"outerLine";
        maskLayer.frame = viewFrame;
        maskLayer.backgroundColor = lineColor.CGColor;
        maskLayer.opacity = 1;
        [view.layer addSublayer:maskLayer];
        
        maskLayer.mask = shapeLayer;
    }
    if (direction & HMOuterLineDirectionLeft) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, weight, layerFrame.size.height)];
        [path fill];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.frame = layerFrame;
        shapeLayer.path = path.CGPath;
        
        CALayer *maskLayer = [CALayer new];
        maskLayer.shouldRasterize = YES;
        maskLayer.name = @"outerLine";
        maskLayer.frame = viewFrame;
        maskLayer.backgroundColor = lineColor.CGColor;
        maskLayer.opacity = 1;
        [view.layer addSublayer:maskLayer];
        
        maskLayer.mask = shapeLayer;
    }
    if (direction & HMOuterLineDirectionRight) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect: CGRectMake(layerFrame.size.width - weight, 0, weight, layerFrame.size.height)];
        [path fill];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.frame = layerFrame;
        shapeLayer.path = path.CGPath;
        
        CALayer *maskLayer = [CALayer new];
        maskLayer.shouldRasterize = YES;
        maskLayer.name = @"outerLine";
        maskLayer.frame = viewFrame;
        maskLayer.backgroundColor = lineColor.CGColor;
        maskLayer.opacity = 1;
        [view.layer addSublayer:maskLayer];
        
        maskLayer.mask = shapeLayer;
    }
    
    UIGraphicsEndImageContext();
}

- (void)clearSubOutLineLayers {
    CALayer* layer = self.layer;
    NSArray* subLayers = layer.sublayers;
    for (NSInteger i = subLayers.count - 1; i >= 0 ; i--) {
        CALayer* subLayer = subLayers[i];
        if ([subLayer.name isEqualToString:@"outerLine"]) {
            [subLayer removeFromSuperlayer];
        }
    }
}


@end
