//
//  CMConstants.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 17..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

//카테고리
#import "NSData+Hash.h"
#import "NSDate+Helper.h"
#import "NSDictionary+DescriptionWithLocale.h"
#import "NSDictionary+Merge.h"
#import "NSMutableDictionary+Merge.h"
#import "NSString+Hash.h"
#import "NSString+Helper.h"
#import "UIImage+Color.h"
#import "UIImage+Path.h"
#import "UIColor+ColorString.h"
#import "UISegmentedControl+Accessibility.h"
#import "UIView+ViewController.h"
#import "UIViewController+OverlayView.h"


//매니저
#import "CMNetworkManager.h"
#import "CMAppManager.h"

// CocoaLumberjack.
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

/**
 *  @brief  CocoaLumberjack 로그레벨 설정.
 
 LOG_LEVEL_ERROR : 에러레벨의 로깅메시지 출력
 LOG_LEVEL_WARN : 에러, 경고레 벨의 로깅메시지 출력
 LOG_LEVEL_INFO : 인포 레벨의 로깅메시지 출력
 LOG_LEVEL_VERBOSE : 모든 로깅메시지 출력
 LOG_LEVEL_OFF : 모든 로깅메시지를 출력하지 않음
 */
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


/**
 *  @brief  App 타입.
 */
typedef NS_ENUM(NSInteger, CMAppType) {
    /**
     *  @brief  아이폰.
     */
    CMAppTypePhone = 0,
    /**
     *  @brief  아이패드.
     */
    CMAppTypePad
};


//##################################################################################################
//  Network Contstants
//##################################################################################################
// 네이버 검색API 키.
extern NSString* const NAVER_SEARCH_API_KEY;

// 네이버 검색API(웹문서) 서버 URL.
extern NSString* const NAVER_SEARCH_API_SERVER_URL;

// C&M SMApplicationSever openAPI 서버 IP.
extern NSString* const CNM_OPEN_API_SERVER_URL;

// C&M SMApplicationSever openAPI 프로토콜 버전.
extern NSString* const CNM_OPEN_API_VERSION;

// 테스트용 터미널Key.
extern NSString* const CNM_TEST_TERMINAL_KEY;

// 기본 정보(지역코드, 상품코드)
extern NSString* const CNM_DEFAULT_AREA_CODE;
extern NSString* const CNM_DEFAULT_PRODUCT_CODE;

// ----------------------------------------------------------------------------------
// 미러TV 에러 메시지.
// ----------------------------------------------------------------------------------

extern NSString* const MIRRORTV_ERROR_MSG_INTRO_2;
extern NSString* const MIRRORTV_ERROR_MSG_INTRO;
extern NSString* const MIRRORTV_ERROR_MSG_VOD;
extern NSString* const MIRRORTV_ERROR_MSG_OTHERS;
extern NSString* const MIRRORTV_ERROR_MSG_BLOCKING_CHANNEL;
extern NSString* const MIRRORTV_ERROR_MSG_STANBY;
extern NSString* const MIRRORTV_ERROR;

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI Parameter Key.
// ----------------------------------------------------------------------------------

// version
extern NSString* const CNM_OPEN_API_VERSION_KEY;

// terminalID
extern NSString* const CNM_OPEN_API_TERMINAL_ID_KEY;

// terminalKey
extern NSString* const CNM_OPEN_API_TERMINAL_KEY_KEY;

// transactionID
extern NSString* const CNM_OPEN_API_TRANSACTION_ID_KEY;

// areaCode
extern NSString* const CNM_OPEN_API_AREA_CODE_KEY;

// produceCode
extern NSString* const CNM_OPEN_API_PRODUCE_CODE_KEY;

// resultCode
extern NSString* const CNM_OPEN_API_RESULT_CODE_KEY;

// resultCode 100(성공)
extern NSString* const CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY;

// 사용자 정보.
extern NSString* const CNM_OPEN_API_USER_INFO_KEY;

// errorString
extern NSString* const CNM_OPEN_API_RESULT_ERROR_STRING_KEY;
extern NSString* const CNM_OPEN_API_RESULT_ERR_STRING_KEY;

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI 인터페이스.
// * Record 관련 인터페이스만 제외됨(TODO: 사용 유무 확인할 것!)
// ----------------------------------------------------------------------------------

// 1. Authenticate
// AuthenticateClient.
extern NSString* const CNM_OPEN_API_INTERFACE_AuthenticateClient;

// GetAppVersionInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetAppVersionInfo;

// GetAppContentVersion
extern NSString* const CNM_OPEN_API_INTERFACE_GetAppContentVersion;

// ClientSetTopBoxRegist
extern NSString* const CNM_OPEN_API_INTERFACE_ClientSetTopBoxRegist;

// CheckRegistUser
extern NSString* const CNM_OPEN_API_INTERFACE_CheckRegistUser;

// AuthenticateAdult
extern NSString* const CNM_OPEN_API_INTERFACE_AuthenticateAdult;

// RequestAuthCode
extern NSString* const CNM_OPEN_API_INTERFACE_RequestAuthCode;

// 2. Channel
// GetChannelGenre
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre;

// GetChannelProduct
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelProduct;

// GetChannelArea
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea;

// GetChannelList
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelList;

// GetChannelSchedule
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule;

// GetChannelMyList
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelMyList;

// SetMyChannel
extern NSString* const CNM_OPEN_API_INTERFACE_SetMyChannel;

// SetMyHiddenChannel
extern NSString* const CNM_OPEN_API_INTERFACE_SetMyHiddenChannel;

// SetMySchedule
extern NSString* const CNM_OPEN_API_INTERFACE_SetMySchedule;

// 3. RemoteController & Message
// SetRemoteChannelControl
extern NSString* const CNM_OPEN_API_INTERFACE_SetRemoteChannelControl;

// SetRemoteVolumeControl
extern NSString* const CNM_OPEN_API_INTERFACE_SetRemoteVolumeControl;

// SetRemotePowerControl
extern NSString* const CNM_OPEN_API_INTERFACE_SetRemotePowerControl;

// SetRemoteMessage
extern NSString* const CNM_OPEN_API_INTERFACE_SetRemoteMessage;

// 4. VOD
// GetVodGenre
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodGenre;

// GetVodGenreInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodGenreInfo;

// GetVodMovie
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodMovie;

// GetVodTv
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodTv;

// GetVodTag
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodTag;

// GetVodTrailer
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodTrailer;

// GetVodMyList
extern NSString* const CNM_OPEN_API_INTERFACE_GetVodMyList;

// SetMyVOD
extern NSString* const CNM_OPEN_API_INTERFACE_SetMyVOD;

// SetVodSetTopDisplayInfo
extern NSString* const CNM_OPEN_API_INTERFACE_SetVodSetTopDisplayInfo;

// Notification
extern NSString* const CNM_OPEN_API_INTERFACE_Notification;

// 5. Search
// SearchChannel
extern NSString* const CNM_OPEN_API_INTERFACE_SearchChannel;

// SearchProgram
extern NSString* const CNM_OPEN_API_INTERFACE_SearchProgram;

// SearchVod
extern NSString* const CNM_OPEN_API_INTERFACE_SearchVod;

// 6.Service
// GetGuideCategory
extern NSString* const CNM_OPEN_API_INTERFACE_GetGuideCategory;

// GetServiceGuideList
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideList;

// GetServiceGuideInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideInfo;

// GetServiceGuideImage
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideImage;

// GetServiceJoinNList
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNList;

// GetServiceJoinNInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNInfo;

// GetServiceNoticeInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceNoticeInfo;




@interface STVConstants : NSObject

@end