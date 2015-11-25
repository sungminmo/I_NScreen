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

#import "CMColor.h"
#import "SIAlertView.h"


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


/**
 *  @brief  성인검색 제한설정 여부.
 */
typedef NS_ENUM(NSInteger, CMContentsRestrictedType) {
    /**
     *  @brief  제한없음.
     */
    CMContentsRestrictedTypeNone = 0,
    /**
     *  @brief  성인물 제한.
     */
    CMContentsRestrictedTypeAdult
};

/**
 *  @brief  성인인증 여부.
 */
typedef NS_ENUM(NSInteger, CMAdultCertificationYN) {
    /**
     *  @brief  성인인증 하지 않음
     */
    CMAdultCertificationNone = 0,
    /**
     *  @brief  성인인증성공.
     */
    CMAdultCertificationSuccess
};


static const CGFloat cmNavigationHeight = 93;//네비게이션 커스텀 높이


//##################################################################################################
//  Network Contstants
//##################################################################################################
// 네이버 검색API 키.
extern NSString* const NAVER_SEARCH_API_KEY;

// 네이버 검색API(웹문서) 서버 URL.
extern NSString* const NAVER_SEARCH_API_SERVER_URL;

// DRM 호출 URL
extern NSString* const DRM_OPEN_API_SERVER_URL;

// C&M SMApplicationSever openAPI 서버 IP.
extern NSString* const CNM_OPEN_API_SERVER_URL;

extern NSString* const CNM_OPEN_API_SERVER_URL_VPN;

// C&M AirCode Server open API 서버 IP
extern NSString* const CNM_AIRCODE_OPEN_API_SERVER_URL;

extern NSString* const CNM_RUMPUS_OPEN_API_SERVER_URL;

// RUMPUS Server VPN 용 open API 서버 IP
extern NSString* const CNM_RUMPUS_OPEN_API_SERVER_URL_VPN;

// C&M SMApplicationSever openAPI 프로토콜 버전.
extern NSString* const CNM_OPEN_API_VERSION;

// 테스트용 터미널Key.
extern NSString* const CNM_TEST_TERMINAL_KEY;

// 실서버용 테스트 터미널 Key.
extern NSString* const CNM_REAL_TEST_TERMINAL_KEY;

// categoryProfile
extern NSString* const CNM_OPEN_API_CATEGORY_PROFILE_KEY;

// traverseType
extern NSString* const CNM_OPEN_API_TRAVERSE_TYPE_KEY;

// 기본 정보(지역코드, 상품코드)
extern NSString* const CNM_DEFAULT_AREA_CODE;
extern NSString* const CNM_DEFAULT_PRODUCT_CODE;


// public terminalKey
extern NSString* const CNM_PUBLIC_TERMINAL_KEY;

// private terminalKey
extern NSString* const CNM_PRIVATE_TERMINAL_KEY;

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
// C&M 키체인에 저장할 key
// ----------------------------------------------------------------------------------
// uuid
extern NSString* const CNM_OPEN_API_UUID_KEY;

// 구매 비밀번호
extern NSString* const CNM_OPEN_API_BUY_PW;

// 프라이빗 터미널 키
extern NSString* const CNM_OPEN_API_PRIVATE_TERMINAL_KEY_KEY;

// 성인 인증 여부 체크
extern NSString* const CNM_OPEN_API_ADULT_CERTIFICATION;

// 성인 검색 제한 설정
extern NSString* const CNM_OPEN_API_ADULT_LIMIT;

// 지역설정
extern NSString* const CNM_OPEN_API_AREA_CODE_VALUE;

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI Parameter Key.
// ----------------------------------------------------------------------------------
// 체널 지역 코드
// CNM 지역 코드
extern NSString* const CNM_AREA_CODE;

// 영화 애니 tv다시보기 성인 오늘의 추천 categoryId 는 고정으로 박음 됨
// 오늘의 추천
extern NSString* const CNM_OPEN_API_RECOMEND_CATEGORY_ID;

// 영화
extern NSString* const CNM_OPEN_API_MOVIE_CATEGORY_ID;

// 애니
extern NSString* const CNM_OPEN_API_ANNI_CATEGORY_ID;

// TV다시보기
extern NSString* const CNM_OPEN_API_TV_REPLAY_CATEGORY_ID;

// 성인
extern NSString* const CNM_OPEN_API_ADULT_CATEGORY_ID;

// assetProfile
extern NSString* const CNM_OPEN_API_ASSET_PROFILE_KEY;

// 페어링후 셋탑이 PVR 인지 HD 인지 체크 값
extern NSString* const CNM_OPEN_API_SET_TOP_BOK_KIND;

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

// 검색된 페이지
extern NSString* const CNM_OPEN_API_RESULT_TOTAL_PAGE;

// 검색된 리스트수
extern NSString* const CNM_OPEN_API_RESULT_TOTAL_COUNT;

// 사용자 정보.
extern NSString* const CNM_OPEN_API_USER_INFO_KEY;

//공지사항 리스트 및 상세의 서비스이용약관, 고객센터안내 분기키 
extern NSString* const CNM_OPEN_API_PREF_GUIDEID_KEY;

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
//extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre;

// GetChannelProduct
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelProduct;

// GetChannelArea
//extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea;

// GetChannelList
//extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelList;

// GetChannelSchedule
//extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule;

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

extern NSString* const CNM_OPEN_API_INTERFACE_GetAssetInfo;

// RecommendContentGroupByAssetId
extern NSString* const CNM_OPEN_API_INTERFACE_RecommendContentGroupByAssetId;

// GetBundleProductList
extern NSString* const CNM_OPEN_API_INTERFACE_GetBundleProductList;

// getCateogryTree
extern NSString* const CNM_OPEN_API_INTERFACE_GetCategoryTree;

// recommendAssetBySubscriber
extern NSString* const CNM_OPEN_API_INTERFACE_RecommendAssetBySubscriber;

// getAppInitialize
extern NSString* const CNM_OPEN_API_INTERFACE_GetAppInitialize;

/// getEventList
extern NSString* const CNM_OPEN_API_INTERFACE_GetEventList;

// getAssetList
extern NSString* const CNM_OPEN_API_INTERFACE_GetAssetList;

// getPurchaseLogList
extern NSString* const CNM_OPEN_API_INTERFACE_GetPurchaseLogList;

// getSeriesAssetList
extern NSString* const CNM_OPEN_API_INTERFACE_GetSeriesAssetList;
///
// addWishItem
extern NSString* const CNM_OPEN_API_INTERFACE_AddWishItem;

// getEpisodePeerListByContentGroupId
extern NSString* const CNM_OPEN_API_INTERFACE_getEpisodePeerListByContentGroupId;

// getAssetListByEpisodePeerId
extern NSString* const CNM_OPEN_API_INTERFACE_getAssetListByEpisodePeerId;

// getCouponBalance2
extern NSString* const CNM_OPEN_API_INTERFACE_getCouponBalance2;

// getPointBalance
extern NSString* const CNM_OPEN_API_INTERFACE_getPointBalance;

// 5. Search
// SearchChannel
extern NSString* const CNM_OPEN_API_INTERFACE_SearchChannel;

// SearchProgram
extern NSString* const CNM_OPEN_API_INTERFACE_SearchProgram;

// SearchVod
extern NSString* const CNM_OPEN_API_INTERFACE_SearchVod;

// SearchWord
extern NSString* const CNM_OPEN_API_INTERFACE_getSearchWord;

// GetPopularityChart
extern NSString* const CNM_OPEN_API_INTERFACE_GetPopularityChart;

// GetContentGroupList
extern NSString* const CNM_OPEN_API_INTERFACE_GetContentGroupList;

// Getservicebannerlist
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceBannerlist;

// searchContentGroup
extern NSString* const CNM_OPEN_API_INTERFACE_SearchContentGroup;

// 6.Service
// GetGuideCategory
extern NSString* const CNM_OPEN_API_INTERFACE_GetGuideCategory;

// GetServiceGuideList
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideList;

// GetServiceGuideImage
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideImage;

// GetServiceJoinNList
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoyNList;

// GetServiceJoinNInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoyNInfo;

// GetServiceNoticeInfo
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceNoticeInfo;

//GetServiceguideInfo 고객센터, 이용약관
extern NSString* const CNM_OPEN_API_INTERFACE_GetServiceguideInfo;


// 7. Epg
// getChannelList
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelList;

// getChannelGenre
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre;

// getChannelArea
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea;

// getChannelSchedule
extern NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule;

// searchSchedule
extern NSString* const CNM_OPEN_API_INTERFACE_SearchSchedule;

// SetRecord
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecord;

// SetRecordStop
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordStop;

// SetRecordReserve
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordReserve;

// SetRecordSeriesReserve
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordSeriesReserve;

// SetRecordCancelReserve
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordCancelReserve;

// 8. Pairing

// addUser
extern NSString* const CNM_OPEN_API_INTERFACE_AddUser;

// authenticateDevice
extern NSString* const CNM_OPEN_API_INTERFACE_AuthenticateDevice;

// removeUser
extern NSString* const CNM_OPEN_API_INTERFACE_RemoveUser;

// 9. pvr
// dev.getrecordlist
extern NSString* const CNM_OPEN_API_INTERFACE_DEV_Getrecordlist;

// dev.getrecordReservelist
extern NSString* const CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist;

//SetRecordDele
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordDele;

//SetRecordSeriesDele
extern NSString* const CNM_OPEN_API_INTERFACE_SetRecordSeriesDele;

// 10. MyC&M
// getValidPurchaseLogList
extern NSString* const CNM_OPEN_API_INTERFACE_GetValidPurchaseLogList;

// getWishList
extern NSString* const CNM_OPEN_API_INTERFACE_GetWishList;

// removeWishItem
extern NSString* const CNM_OPEN_API_INTERFACE_RemoveWishItem;

// remocon
//GetSetTopStatus
extern NSString* const CNM_OPEN_API_INTERFACE_GetSetTopStatus;

// disablePurchaseLog
extern NSString* const CNM_OPEN_API_INTERFACE_disablePurchaseLog;

//노티피게이션
extern NSString* const CNMHandleOpenURLNotification;

// 10. payment
// GetAvailablePaymentType
extern NSString* const CNM_OPEN_API_INTERFACE_GetAvailablePaymentType;

// PurchaseByPoint
extern NSString* const CNM_OPEN_API_INTERFACE_PurchaseByPoint;

// PurchaseAssetEx2
extern NSString* const CNM_OPEN_API_INTERFACE_PurchaseAssetEx2;

@interface STVConstants : NSObject

@end
