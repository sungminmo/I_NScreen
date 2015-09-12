//
//  CMConstants.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 17..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMConstants.h"

// 네이버 검색API 키.
NSString* const NAVER_SEARCH_API_KEY = @"7868041a52660445b7e1d4bb4f24709c";//발급 2015.09.08 com.voapp.I_NScreen

// 네이버 검색API(웹문서) 서버 URL.
NSString* const NAVER_SEARCH_API_SERVER_URL = @"http://openapi.naver.com/search?";

// C&M SMApplicationSever openAPI 서버 IP.
NSString* const CNM_OPEN_API_SERVER_URL = @"http://58.143.243.91/SMApplicationServer/";

// C&M SMApplicationSever openAPI 프로토콜 버전.
NSString* const CNM_OPEN_API_VERSION = @"SmartMobile_v1.0.0";

// 테스트용 터미널Key.
NSString* const CNM_TEST_TERMINAL_KEY = @"FAC7AE9F9936BBFEB468F2F6FBEA240";

// 기본 정보(지역코드, 상품코드)
NSString* const CNM_DEFAULT_AREA_CODE = @"12";
NSString* const CNM_DEFAULT_PRODUCT_CODE = @"12";

// ----------------------------------------------------------------------------------
// 미러TV 에러 메시지.
// ----------------------------------------------------------------------------------

NSString* const MIRRORTV_ERROR_MSG_INTRO_2 = @"해당 채널은 미러TV가 지원되지 않습니다.\n※ 지상파 등 일부 채널은 지원되지 않습니다.\n※ 채널 전환 시, 화면 전송이 지연될 수 있습니다.";
NSString* const MIRRORTV_ERROR_MSG_INTRO = @"지상파 채널등 일부 채널은\n미러TV가 지원되지 않습니다.";
NSString* const MIRRORTV_ERROR_MSG_VOD = @"TV는 채널 상태일 경우에만 미러TV가 실행됩니다.";
NSString* const MIRRORTV_ERROR_MSG_OTHERS = @"TV가 채널 상태일 경우에만 미러TV가 실행됩니다.";
NSString* const MIRRORTV_ERROR_MSG_BLOCKING_CHANNEL = @"셋탑박스에서 성인인증 또는 구매 완료 후\n 다시 이용해 주세요.";
NSString* const MIRRORTV_ERROR_MSG_STANBY = @"셋탑박스 전원이 꺼져있습니다.\n전원을 켜신 후 이용바랍니다.";
NSString* const MIRRORTV_ERROR = @"미러TV 영상이 지연되고 있습니다.\n잠시 후 다시 이용해 주십시오.";

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI Parameter Key.
// ----------------------------------------------------------------------------------

// version
NSString* const CNM_OPEN_API_VERSION_KEY = @"version";

// terminalID
NSString* const CNM_OPEN_API_TERMINAL_ID_KEY = @"terminalId";

// terminalKey
NSString* const CNM_OPEN_API_TERMINAL_KEY_KEY = @"terminalKey";

// transactionID
NSString* const CNM_OPEN_API_TRANSACTION_ID_KEY = @"transactionId";

// areaCode
NSString* const CNM_OPEN_API_AREA_CODE_KEY = @"aredCode";

// produceCode
NSString* const CNM_OPEN_API_PRODUCE_CODE_KEY = @"produceCode";

// resultCode
NSString* const CNM_OPEN_API_RESULT_CODE_KEY = @"resultCode";

// resultCode 100(성공)
NSString* const CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY = @"100";

// 사용자 정보.
NSString* const CNM_OPEN_API_USER_INFO_KEY = @"UserInfo";

// errorString
NSString* const CNM_OPEN_API_RESULT_ERROR_STRING_KEY = @"errorString";
NSString* const CNM_OPEN_API_RESULT_ERR_STRING_KEY = @"errString";

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI 인터페이스.
// * Record 관련 인터페이스만 제외됨(TODO: 사용 유무 확인할 것!)
// ----------------------------------------------------------------------------------

// 1. Authenticate
// AuthenticateClient.
NSString* const CNM_OPEN_API_INTERFACE_AuthenticateClient = @"AuthenticateClient";

// GetAppVersionInfo
NSString* const CNM_OPEN_API_INTERFACE_GetAppVersionInfo = @"GetAppVersionInfo";

// GetAppContentVersion
NSString* const CNM_OPEN_API_INTERFACE_GetAppContentVersion = @"GetAppContentVersion";

// ClientSetTopBoxRegist
NSString* const CNM_OPEN_API_INTERFACE_ClientSetTopBoxRegist = @"ClientSetTopBoxRegist";

// CheckRegistUser
NSString* const CNM_OPEN_API_INTERFACE_CheckRegistUser = @"CheckRegistUser";

// AuthenticateAdult
NSString* const CNM_OPEN_API_INTERFACE_AuthenticateAdult = @"AuthenticateAdult";

// RequestAuthCode
NSString* const CNM_OPEN_API_INTERFACE_RequestAuthCode = @"RequestAuthCode";

// 2. Channel
// GetChannelGenre
NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre = @"GetChannelGenre";

// GetChannelProduct
NSString* const CNM_OPEN_API_INTERFACE_GetChannelProduct = @"GetChannelProduct";

// GetChannelArea
NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea = @"GetChannelArea";

// GetChannelList
NSString* const CNM_OPEN_API_INTERFACE_GetChannelList = @"GetChannelList";

// GetChannelSchedule
NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule = @"GetChannelSchedule";

// GetChannelMyList
NSString* const CNM_OPEN_API_INTERFACE_GetChannelMyList = @"GetChannelMyList";

// SetMyChannel
NSString* const CNM_OPEN_API_INTERFACE_SetMyChannel = @"SetMyChannel";

// SetMyHiddenChannel
NSString* const CNM_OPEN_API_INTERFACE_SetMyHiddenChannel = @"SetMyHiddenChannel";

// SetMySchedule
NSString* const CNM_OPEN_API_INTERFACE_SetMySchedule = @"SetMySchedule";

// 3. RemoteController & Message
// SetRemoteChannelControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteChannelControl = @"SetRemoteChannelControl";

// SetRemoteVolumeControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteVolumeControl = @"SetRemoteVolumeControl";

// SetRemotePowerControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemotePowerControl = @"SetRemotePowerControl";

// SetRemoteMessage
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteMessage = @"SetRemoteMessage";

// 4. VOD
// GetVodGenre
NSString* const CNM_OPEN_API_INTERFACE_GetVodGenre = @"GetVodGenre";

// GetVodGenreInfo
NSString* const CNM_OPEN_API_INTERFACE_GetVodGenreInfo = @"GetVodGenreInfo";

// GetVodMovie
NSString* const CNM_OPEN_API_INTERFACE_GetVodMovie = @"GetVodMovie";

// GetVodTv
NSString* const CNM_OPEN_API_INTERFACE_GetVodTv = @"GetVodTv";

// GetVodTag
NSString* const CNM_OPEN_API_INTERFACE_GetVodTag = @"GetVodTag";

// GetVodTrailer
NSString* const CNM_OPEN_API_INTERFACE_GetVodTrailer = @"GetVodTrailer";

// GetVodMyList
NSString* const CNM_OPEN_API_INTERFACE_GetVodMyList = @"GetVodMyList";

// SetMyVOD
NSString* const CNM_OPEN_API_INTERFACE_SetMyVOD = @"SetMyVOD";

// SetVodSetTopDisplayInfo
NSString* const CNM_OPEN_API_INTERFACE_SetVodSetTopDisplayInfo = @"SetVodSetTopDisplayInfo";

// Notification
NSString* const CNM_OPEN_API_INTERFACE_Notification = @"Notification";

// 5. Search
// SearchChannel
NSString* const CNM_OPEN_API_INTERFACE_SearchChannel = @"SearchChannel";

// SearchProgram
NSString* const CNM_OPEN_API_INTERFACE_SearchProgram = @"SearchProgram";

// SearchVod
NSString* const CNM_OPEN_API_INTERFACE_SearchVod = @"SearchVod";

// 6.Service
// GetGuideCategory
NSString* const CNM_OPEN_API_INTERFACE_GetGuideCategory = @"GetGuideCategory";

// GetServiceGuideList
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideList = @"GetServiceGuideList";

// GetServiceGuideInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideInfo = @"GetServiceGuideInfo";

// GetServiceGuideImage
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideImage = @"GetServiceGuideImage";

// GetServiceJoinNList
NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNList = @"GetServiceJoinNList";

// GetServiceJoinNInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNInfo = @"GetServiceJoinNInfo";

// GetServiceNoticeInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceNoticeInfo = @"GetServiceNoticeInfo";


@implementation STVConstants

@end
