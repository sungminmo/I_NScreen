//
//  UserClass.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineData.h"

@class DataManager;

@interface UserClass : NSObject
{ 

}

// 왼쪽 뷰 컨트롤러 호출
- (void)onLeftBtnClickWithControl:(id)control;

// 왼쪽 뷰 컨트롤러 닫음
- (void)onCloseBtnClickWithControl:(id)control;

@end
