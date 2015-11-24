//
//  StrikethroughLabel.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "StrikethroughLabel.h"
#import <QuartzCore/QuartzCore.h>

#define STRIKEOUT_THICKNESS 2.0f

@interface StrikethroughLabel ()
{
    CALayer *strikeThroughLayer;
}

- (void)makeStrikeThrough;
@end

@implementation StrikethroughLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ) {
        strikeThroughLayer = [CALayer layer];
        
        strikeThroughLayer.backgroundColor = [[UIColor grayColor] CGColor];
        
        strikeThroughLayer.hidden = YES;
        
        [self.layer addSublayer:strikeThroughLayer];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self makeStrikeThrough];
}

- (void)makeStrikeThrough
{
    CGSize textSize = [self.text sizeWithFont:self.font];
    
    strikeThroughLayer.frame = CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKEOUT_THICKNESS);
    
}

- (void)setIsStrikeThrough:(BOOL)isStrikeThrough
{
    _isStrikeThrough = isStrikeThrough;
    
    strikeThroughLayer.hidden = !_isStrikeThrough;
    
    if ( _isStrikeThrough )
    {
        self.textColor = [UIColor grayColor];
    }
}

@end
