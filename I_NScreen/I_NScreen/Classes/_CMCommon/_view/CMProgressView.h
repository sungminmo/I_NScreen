//
//  CMProgressView.h
//  autolayoutTest
//
//  Created by kimts on 2015. 11. 2..
//  Copyright © 2015년 kimteaksoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMProgressView : UIView


//- (id)initWithPoint:(CGPoint)point trailingSpace:(CGFloat)space;

/**
 *  프로그래스바 길이를 0으로 리셋한다.
 */
- (void)reset;

/**
 *  프로그래스바의 길이를 주어진 비율에 맞춰 변경한다.
 *
 *  @param ratio    전체 길이에 대한 프로그래스바의 비율 (0 ~ 1)
 *  @param animated 애니메이션 여부
 */
- (void)setProgressRatio:(CGFloat)ratio animated:(BOOL)animated;

@end
