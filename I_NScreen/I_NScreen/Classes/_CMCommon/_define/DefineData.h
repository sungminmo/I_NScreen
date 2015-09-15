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
#define DEV_HOST            @"http://m.dibidibi.com"

/*================================================================================================================
 해상도 값 정의
 ================================================================================================================ */
#define IPHONE_RESOLUTION_6_PLUS    @"IPHONE_RESOLUTION_6_PLUS"
#define IPHONE_RESOLUTION_6         @"IPHONE_RESOLUTION_6"
#define IPHONE_RESOLUTION_5         @"IPHONE_RESOLUTION_5"
#define IPHONE_RESOLUTION_ELSE      @"IPHONE_RESOLUTION_ELSE"


/*================================================================================================================
 화면에 사용될 버튼 이벤트 값 정의
================================================================================================================ */
// HomeGnbViewController btn tag
#define HOME_GNB_VIEW_BTN_TAG_01       10000       //

// EpgMainViewController btn tag
#define EPG_MAIN_VIEW_BTN_TAG_01        10001   // back 버튼
#define EPG_MAIN_VIEW_BTN_TAG_02        10002   // popup 호출
#define EPG_MAIN_VIEW_BTN_TAG_03        10003   // 

// EpgPopUpViewController btn tag
#define EPG_POPUP_VIEW_BTN_01           10101   // BACK 버튼
#define EPG_POPUP_VIEW_BTN_02           10102   // 전체채널 버튼
#define EPG_POPUP_VIEW_BTN_03           10103   // 선호채널 버튼

// EpgSubViewController btn tag
#define EPG_SUP_VIEW_BTN_01             10201   // back 버튼
#define EPG_SUP_VIEW_BTN_02             10202   // 하트 버튼

// RecodeMainViewController btn tag
#define RECODE_MAIN_VIEW_BTN_01         10301   // back 버튼
#define RECODE_MAIN_VIEW_BTN_02         10302   // 녹화예약 관리 버튼
#define RECODE_MAIN_VIEW_BTN_03         10303   // 녹화물 목록 버튼

// RecodeSubViewController btn tag
#define RECODE_SUB_VIEW_BTN_01          10401   // back 버튼

/*
문자열 정의
//*/
#define MSG1    @"서버로부터 정보를 가져올수없습니다.\n다시 시도 바랍니다."


/*================================================================================================================
 전문 헤더에 사용될 코드값 정의
 ================================================================================================================ */
#define TRINFO_TEST             100001


#endif

