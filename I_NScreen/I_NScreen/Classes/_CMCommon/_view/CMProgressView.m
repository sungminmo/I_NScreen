//
//  CMProgressView2.m
//  autolayoutTest
//
//  Created by kimts on 2015. 11. 2..
//  Copyright © 2015년 kimteaksoo. All rights reserved.
//

#import "CMProgressView.h"
#import "CMColor.h"

@interface CMProgressView ()

@property (strong, nonatomic) UIView* progressBar;

@end

@implementation CMProgressView

- (void)awakeFromNib {
    
    self.backgroundColor = [CMColor colorProgressBackground];
    
    CGRect frame = CGRectMake(0, 0, 0, 3);
    self.progressBar = [[UIView alloc] initWithFrame:frame];
    self.progressBar.backgroundColor = [CMColor colorViolet];
    [self addSubview:self.progressBar];
}

/*- (id)initWithPoint:(CGPoint)point trailingSpace:(CGFloat)space {
    CGRect frame = CGRectMake(point.x, point.y, 0, 3);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [CMColor colorProgressBackground];
        
        frame = CGRectMake(0, 0, 0, 3);
        self.progressBar = [[UIView alloc] initWithFrame:frame];
        self.progressBar.backgroundColor = [CMColor colorViolet];
        [self addSubview:self.progressBar];
    }
    
    return self;
}*/

#pragma mark - Public

/**
 *  프로그래스바 길이를 0으로 리셋한다.
 */
- (void)reset {
    
    [self layoutIfNeeded];
    
    [self setProgressRatio:0 animated:NO];
}

/**
 *  프로그래스바의 길이를 주어진 비율에 맞춰 변경한다.
 *
 *  @param ratio    전체 길이에 대한 프로그래스바의 비율 (0 ~ 1)
 *  @param animated 애니메이션 여부
 */
- (void)setProgressRatio:(CGFloat)ratio animated:(BOOL)animated{
    
    [self layoutIfNeeded];
    
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){

        CGFloat width = self.bounds.size.width * ratio;
        
        if (animated) {
            
            [UIView animateWithDuration:.3 animations:^{
                CGRect frame = self.progressBar.frame;
                frame.size.width = width;
                self.progressBar.frame = frame;
            }];
        } else {
            
            CGRect frame = self.progressBar.frame;
            frame.size.width = width;
            self.progressBar.frame = frame;
        }
    });
}

@end
