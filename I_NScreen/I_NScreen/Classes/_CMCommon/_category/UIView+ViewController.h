//
//  UIView+ViewController.h
//  STVN
//
//  Created by 조백근 on 2014. 10. 23..
//
//

#import <UIKit/UIKit.h>

/** UIView 카테고리 클래스
 */

@interface UIView (UIViewController)

/**
*  @brief  UIViewController 객체를 반환.
*          UIView를 소유하고 있는 UIViewController 객체를 반환한다. 반환할 객체가 없으면 nil을 반환한다.
*
*  @return UIViewController.
*/
- (UIViewController *)viewController;

@end
