//
//  UIImage+Color.h
//  STVN
//
//  Created by 조백근 on 2015. 6. 17..
//
//

#import <UIKit/UIKit.h>
#import "UIView+Layer.h"

@interface UIImage (Color)

/**
 *  @brief  컬러를 사용해서 이미지를 생성
 *
 *  @param color 이미지로 변환할 컬러
 *  @param alpha 알파값정보
 *
 *  @return 이미지
 */
+ (UIImage *)image1x1WithColor:(UIColor *)color withAlpha:(CGFloat)alpha;

/**
 *  @brief  컬러를 사용해서 이미지를 생성
 *
 *  @param color 이미지로 변환할 컬러
 *  @param alpha 알파값정보
 *  @param size 이미지 크기
 *
 *  @return 이미지
 */
+ (UIImage *)imageWithColor:(UIColor *)color withAlpha:(CGFloat)alpha withSize:(CGSize)size;

/**
 *  @brief  특정 사이즈의 투명한 이미지를 생성한다.
 *
 *  @param size 생성할 이미지 사이즈
 *
 *  @return 투명이미지
 */
+ (UIImage *)clearImageSize:(CGSize)size;


/**
 *  이미지를 머지한다.
 *
 *  @param firstImage  첫번째 이미지
 *  @param secondImage 두번째 이미지
 *
 *  @return 합친 이미지
 */
+ (UIImage*)ImageMerge:(UIImage* ) firstImage image:(UIImage*) secondImage;



/**
 *  direction 방향에 따라 전달받은 뷰의 외곽에 라인을 그린다.
 *
 *  @param view      라인을 그릴 타겟 뷰
 *  @param direction 라인을 그릴 방향
 *  @param weight    라인의 두께
 *  @param color     라인컬러
 */
+ (UIImage* )setOuterLine:(UIImage*)image direction:(HMOuterLineDirection)direction lineWeight:(CGFloat)weight lineColor:(UIColor*) color;


/**
 *  이미지 테두리를 라운드 처리한다.
 *
 *  @param image  라운드할 이미지
 *  @param radius 라운드 정도
 *
 *  @return 라운드 처리결과 이미지
 */
- (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;


/**
 *  배경 이미지 위에 레이블의 텍스트를 합성해서 새로운 이미지를 생성
 *
 *  @param label 합성할 텍스트를 가진 레이블
 *  @param image 배경이미지
 *  @param yn 배경이미지위에 레이블의 시작 좌표 초기화 여부 
 *
 *  @return 새 이미지
 */
+ (UIImage*)imageWithLabel:(UILabel*)label image:(UIImage*)image isOriginZero:(BOOL)yn;


/**
 *  이미지와 레이블을 합성한다.
 *
 *  @param label    합성할 레이블
 *  @param image    합성할 이미지
 *  @param imgSize  새로운 이미지 사이즈
 *  @param imgPoint 합성할 이미지 위치
 *
 *  @return 새 이미지 
 */
+ (UIImage*)imageWithLabel:(UILabel*)label image:(UIImage*)image newSize:(CGSize)imgSize imagePoint:(CGPoint)imgPoint isBold:(BOOL)isBold;


/**
 *  버튼에 사용할 이미지를 생성한다.
 *
 *  @param sizeForButton 이미지 사이즈
 *  @param bgImage       배경이미지
 *  @param symbol        심볼이미지
 *  @param symRect       심볼영역
 *  @param text          텍스트
 *  @param textPoint     텍스트시작좌표
 *  @param textHeight   텍스트 높이
 *  @param fontValue     텍스트크기
 *  @param textColor     텍스트컬러
 *  @param bold          텍스트굵기
 *
 *  @return 이미지 
 */
+ (UIImage*)imageForButton:(CGSize)sizeForButton bgImage:(UIImage*)bgImage symbol:(UIImage*)symbol symbolRect:(CGRect)symRect text:(NSString*)text point:(CGPoint)textPoint textHeight:(float)textHeight fontValue:(CGFloat)fontValue textColor:(UIColor*)textColor bold:(BOOL)bold;

@end
