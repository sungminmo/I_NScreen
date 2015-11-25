//
//  StrikethroughLabel.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "StrikethroughLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation StrikethroughLabel

@synthesize strikeThroughEnabled = _strikeThroughEnabled;

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
//    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName:[self font]}];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    
//    if ([self textAlignment] == UITextAlignmentRight) {
    if ([self textAlignment] == NSTextAlignmentRight) {
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 1);
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1);
    } else {
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
    }
    
    if (_strikeThroughEnabled) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, lineRect);
    }
}

- (void)setStrikeThroughEnabled:(BOOL)strikeThroughEnabled {
    
    _strikeThroughEnabled = strikeThroughEnabled;
    
    NSString *tempText = [self.text copy];
    self.text = @"";
    self.text = tempText;
}


@end
