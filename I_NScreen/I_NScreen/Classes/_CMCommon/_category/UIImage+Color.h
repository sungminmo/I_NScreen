//
//  UIImage+Color.h
//  STVN
//
//  Created by 조백근 on 2014. 11. 3..
//
//

#import <UIKit/UIKit.h>

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

@end
