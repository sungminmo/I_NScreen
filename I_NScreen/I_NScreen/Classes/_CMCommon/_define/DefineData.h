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
#define HOME_GNB_VIEW_BTN_01            10000       //
#define HOME_GNB_VIEW_BTN_02            10001   // 검색 버튼
#define HOME_GNB_VIEW_BTN_03            10002   // 추천 버튼
#define HOME_GNB_VIEW_BTN_04            10003   // 영화 버튼
#define HOME_GNB_VIEW_BTN_05            10004   // 애니키즈 버튼
#define HOME_GNB_VIEW_BTN_06            10005   // 인기프로그램 버튼
#define HOME_GNB_VIEW_BTN_07            10006   // 성인 버튼
#define HOME_GNB_VIEW_BTN_08            10007   // 테스트 버튼

// EpgMainViewController btn tag
#define EPG_MAIN_VIEW_BTN_TAG_01        10001   // back 버튼
#define EPG_MAIN_VIEW_BTN_TAG_02        10002   // popup 호출
#define EPG_MAIN_VIEW_BTN_TAG_03        10003   // 

// EpgPopUpViewController btn tag
#define EPG_POPUP_VIEW_BTN_01           10101   // BACK 버튼
#define EPG_POPUP_VIEW_BTN_02           10102   // 전체채널 버튼
#define EPG_POPUP_VIEW_BTN_03           10103   // 선호채널 버튼
#define EPG_POPUP_VIEW_BTN_04           10104   // BG 버튼

// EpgSubViewController btn tag
#define EPG_SUP_VIEW_BTN_02             10202   // 하트 버튼


// MyCMMainViewController btn tag
#define MY_CM_MAIN_VIEW_BTN_01          10501   // back 버튼
#define MY_CM_MAIN_VIEW_BTN_02          10502   // VOD 찜목록
#define MY_CM_MAIN_VIEW_BTN_03          10503   // VOD 시청목록
#define MY_CM_MAIN_VIEW_BTN_04          10504   // VOD 구매목록

// RecommendMainViewController btn tag
#define RECOMMEND_MAIN_VIEW_BTN_01      10601   // 인기 순위 더보기
#define RECOMMEND_MAIN_VIEW_BTN_02      10602   // 금주의 신작 영화
#define RECOMMEND_MAIN_VIEW_BTN_03      10603   // 이달의 추천 VOD

// MovieMainViewController btn tag
//#define MOVIE_MAIN_VIEW_BTN_01          10701   // 카테고리 리스트 버튼

// MoviePopUpViewController btn tag
#define MOVICE_POPUP_VIEW_BTN_01        10801   // 닫기 버튼

// PvrMainViewController btn tag
#define PVR_MAIN_VIEW_BTN_02            10902   // 녹화예약 관리 버튼
#define PVR_MAIN_VIEW_BTN_03            10903   // 녹화물 목록 버튼

// PvrSubViewController btn tag

// RemoconMainViewController btn tag
#define REMOCON_MAIN_VIEW_BTN_01        12001   // BACK 버튼
#define REMOCON_MAIN_VIEW_BTN_02        12002   // 전원 버튼
#define REMOCON_MAIN_VIEW_BTN_03        12003   // 채널 버튼
#define REMOCON_MAIN_VIEW_BTN_04        12004   // 볼륨 다운
#define REMOCON_MAIN_VIEW_BTN_05        12005   // 볼륨 업

// AniKidsMainViewController btn tag
#define ANI_KIDS_MAIN_VIEW_BTN_01       13001   // 인기 순위 버튼
#define ANI_KIDS_MAIN_VIEW_BTN_02       13002   // 실시간 인기순위 버튼
#define ANI_KIDS_MAIN_VIEW_BTN_03       13003   // 주간 인기순위 버튼
#define ANI_KIDS_MAIN_VIEW_BTN_04       13004   // 그외 순위 버튼

// MovieMainViewController btn tag
#define MOVIE_MAIN_VIEW_BTN_01          14001   // 인기 순위 버튼
#define MOVIE_MAIN_VIEW_BTN_02          14002   // 실시간 인기 순위 버튼
#define MOVIE_MAIN_VIEW_BTN_03          14003   // 주간 인기 순위 버튼
#define MOVIE_MAIN_VIEW_BTN_04          14004   // 그외 순위 버튼

// 페어링
// PairingMainViewController btn tag
#define PAIRING_MAIN_VIEW_BTN_01        15001   // back 버튼
#define PAIRING_MAIN_VIEW_BTN_02        15002   // 등록 취소
#define PAIRING_MAIN_VIEW_BTN_03        15003   // 다음단계

// PairingAuthViewController btn tag
#define PAIRING_AUTH_VIEW_BTN_01        16001   // BACK 버튼
#define PAIRING_AUTH_VIEW_BTN_02        16002   // 등록 취소
#define PAIRING_AUTH_VIEW_BTN_03        16003   // 등록 완료

// PairingFinishViewController btn tag
#define PAIRING_FINISH_VIEW_BTN_01      17001   // 완료

// PairingRePwViewController btn tag
#define PAIRING_RE_PW_VIEW_BTN_01       18001   // BACK 버튼
#define PAIRING_RE_PW_VIEW_BTN_02       18002   // 설정 취소
#define PAIRING_RE_PW_VIEW_BTN_03       18003   // 설정 완료

// TestPageViewController btn tag
#define TEST_PAGE_VIEW_BTN_01           19001
#define TEST_PAGE_VIEW_BTN_02           19002
#define TEST_PAGE_VIEW_BTN_03           19003

// VodDetailMainViewController btn tag
#define VOD_DETAIL_MAIN_VIEW_BTN_01     20001   // BACK 버튼
#define VOD_DETAIL_MAIN_VIEW_BTN_02     20002   // 시청 하기 버튼

//

/*
문자열 정의
//*/
#define MSG1    @"서버로부터 정보를 가져올수없습니다.\n다시 시도 바랍니다."


/*================================================================================================================
 전문 헤더에 사용될 코드값 정의
 ================================================================================================================ */
#define TRINFO_TEST             100001


#endif

