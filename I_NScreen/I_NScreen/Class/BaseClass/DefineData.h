//
//  DefineData.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//


#ifndef DefineData_h
#define DefineData_h

#define	NScreen_DEVICE                 // ifdef:테스트서버 / else:리얼서버

// 주석을 사용하고 한번에 닫기 위해서 만들어둔 Define값
#define	NScreen_DEBUG                  // ifdef:주석 사용 / else:주석 닫기


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 널데이터 처리
#define IS_NOT_NSNULL(X)    X != [NSNull null] && X != nil ? YES : NO

// host
//#define DEV_HOST            @"https://raw.githubusercontent.com"
#define DEV_HOST            @"http://m.dibidibi.com"



/*================================================================================================================
 화면에 사용될 버튼 이벤트 값 정의
================================================================================================================ */

/*
문자열 정의
//*/
#define MSG1    @"서버로부터 정보를 가져올수없습니다.\n다시 시도 바랍니다."


/*================================================================================================================
 전문 헤더에 사용될 코드값 정의
 ================================================================================================================ */
#define TRINFO_TEST             100001


#endif

