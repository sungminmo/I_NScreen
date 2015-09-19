//
//  UIView+Layer.h
//  STVN
//
//  Created by 조백근 on 2015. 6. 19..
//
//

#import <UIKit/UIKit.h>

//뷰의 외곽선을 그리기 위한 타입
typedef enum {
    HMOuterLineDirectionTop = 1 <<  0,
    HMOuterLineDirectionBottom = 1 <<  1,
    HMOuterLineDirectionLeft = 1 <<  2,
    HMOuterLineDirectionRight = 1 <<  3,
    HMOuterLineDirectionRightBottom = (HMOuterLineDirectionRight | HMOuterLineDirectionBottom),
    HMOuterLineDirectionAll = (HMOuterLineDirectionTop | HMOuterLineDirectionBottom | HMOuterLineDirectionLeft | HMOuterLineDirectionRight)
} HMOuterLineDirection;


@interface UIView (Layer)

/**
 *  UIView의 각 모서리 꼭지점을 라운드 처리 한다.
 *
 *  @param view    꼭지점을 라운드 처리할 대상객체
 *  @param corners 라운드처리할 꼭지점 위치
 *  @param radious 라운드 정도
 */
-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners radious:(CGFloat)radious;

/**
 *  direction 방향에 따라 전달받은 뷰의 외곽에 라인을 그린다.
 *
 *  @param view      라인을 그릴 타겟 뷰
 *  @param direction 라인을 그릴 방향
 *  @param weight    라인의 두께
 *  @param color     라인컬러
 */
+ (void)setOuterLine:(UIView*)view direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color;

/**
 *  direction 방향에 따라 전달받은 뷰의 외곽에 라인을 그린다.
 *
 *  @param view      라인을 그릴 타겟 뷰
 *  @param layerFrame 라인을 그려야 할 영역 
 *  @param direction 라인을 그릴 방향
 *  @param weight    라인의 두께
 *  @param color     라인컬러
 */
+ (void)setOuterLine:(UIView*)view Frame:(CGRect)layerFrame direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color;

+ (void)setTriangleWithColor:(UIColor*)fill view:(UIView*)view;


- (void)clearSubOutLineLayers;

@end
