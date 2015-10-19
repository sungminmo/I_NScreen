//
//  CMAppManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CMAppManager : NSObject

+ (CMAppManager *)sharedInstance;


/**
 *  @brief  기본값 설정.
 */
- (void)defaultSetting;


/**
 공용 클래스 메서드 CMAppManager 에 만들면 되나요?
 */

/**
 * @brief 왼쪽 메뉴 open
 */
- (void)onLeftMenuListOpen:(id)control;

/**
 * @brief 왼쪽 메뉴 close
 */
- (void)onLeftMenuListClose:(id)control;

/**
 * @brief 디바이스 체크
 */
- (NSString *)getDeviceCheck;




@end
