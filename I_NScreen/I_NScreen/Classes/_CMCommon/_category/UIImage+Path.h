//
//  UIImage+Path.h
//  STVN
//
//  Created by lambert on 2014. 11. 5..
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Path)

/**
 *  @brief  이미지의 경로를 이용해 이미지를 읽어 온다.
 *          앱의 Documents 디렉토리에 다운로드 받은 이미지를 읽는 용도.
 *
 *  @warning 번들에서 읽어 오는 것이 아님에 주의할 것!
 *  @param path 이미지 전체 경로.
 *
 *  @return UIImage.
 */
+ (UIImage *)setImageWithPath:(NSString *)path;

@end
