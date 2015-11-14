//
//  CMPaytvGuideViewController.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CMPaytvGuideViewController : CMBaseViewController

/**
 *  유료채널정보를 받아서 화면을 생성
 *
 *  @param item 유료채널정보
 *
 *  @return 자신객체 
 */
- (id)initWithGuideInfo:(NSDictionary*)item;

@end
