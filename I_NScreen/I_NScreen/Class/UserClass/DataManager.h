//
//  DataManager.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import <Foundation/Foundation.h>
// 공통으로 사용될 함수 모음
#import "UserClass.h"
#import "JSON.h"

@protocol DataManagerDelegate;

@interface DataManager : NSObject
{
    // 공통컨트롤 클래스 선언
    UserClass               *p_gUserClass;
    // 최상위 뷰클래스
    id                     p_gViewController;
}

+ (DataManager *)getInstance;
- (void)execute;
// 공통컨트롤 클래스 선언
@property (nonatomic, assign)UserClass               *p_gUserClass;
// 최상위 뷰클래스
@property (nonatomic, assign)id                      p_gViewController;

@end
